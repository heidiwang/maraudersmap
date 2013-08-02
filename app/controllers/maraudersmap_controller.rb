require 'open-uri'
require 'rubygems'
require 'json'

class MaraudersmapController < ApplicationController

  before_filter :index

  def index
   	@url = "https://net-util4001.ecr.box.net:4743/network/wireless_associations.json"
   	@file = open(@url)
   	@contents = @file.read

   	@parsed = JSON.parse(@contents)
   	$users = Hash.new

    @parsed.each do |item|
    	username = item[1]["username"]
    	ap = item[1]["ap"]
    	if (is_ecr(ap) && !is_guest(username) && is_alphanumeric(username))
    		$users[username] = parse_hub_data(ap)
    	end
   	end
  end

  def first
  	@first_floor_users = get_floor(1)
  end

  def second
  	@second_floor_users = get_floor(2)
  end

  def third
  	@third_floor_users = get_floor(3)
  end

  private
  def is_ecr(ap_name)
  	return (!ap_name.nil? && ap_name.end_with?(".ecr")) \
  	|| (ap_name == "6c:f3:7f:c3:07:10") || (ap_name == "6c:f3:7f:c3:07:46")
  end

  def is_guest(username)
  	return ((username.nil?) || (username == "\"\""))
  end

  def is_alphanumeric(username)
  	return username.match(/^[[:alpha:]]+$/)
  end

  def parse_hub_data(hubname)
  	if (hubname == "6c:f3:7f:c3:07:10")
  		return {"floor" => 2, "hub" => 11}
  	elsif (hubname == "6c:f3:7f:c3:07:46")
  		return {"floor" => 3, "hub" => 10}
  	end

  	data = Hash.new
  	split_hubname = hubname.split(/\.|\-/)
  	data["floor"] = split_hubname[1].to_i
  	data["hub"] = split_hubname[2].to_i
  	return data               
  end

  def get_floor(floornumber)
	@floor_users = Hash.new
  	$users.each do |user, location|
  		if(location["floor"] == floornumber)
  			if (@floor_users[(location["hub"])].nil?)
  				@floor_users[(location["hub"])] = Array.new
  			end
  			@floor_users[(location["hub"])] << user
  		end
  	end
  	return @floor_users
  end
end
