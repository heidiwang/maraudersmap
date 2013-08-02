require 'open-uri'
require 'rubygems'
require 'json'

class MaraudersmapController < ApplicationController
  before_action :index

  def index
   	@url = "https://net-util4001.ecr.box.net:4743/network/wireless_associations.json"
   	@file = open(@url)
   	@contents = @file.read

   	@parsed = JSON.parse(@contents)
   	$users = Hash.new
   	$hubs = Hash.new

    @parsed.each do |item|
    	username = item[1]["username"]
    	ap = item[1]["ap"]
    	if (is_ecr(ap) && !is_guest(username) && is_alphanumeric(username))
    		$users[username] = ap
    		if ($hubs[ap].nil?)
    			$hubs[ap] = Array.new
    		end
    		$hubs[ap] << username
    	end
   	end
  end

  def first
  	@foo = "hello"
  end

  def second
  end

  def third
  end

  private
  def is_ecr(ap_name)
  	return (!ap_name.nil? && ap_name.end_with?(".ecr"))
  end

  def is_guest(username)
  	return ((username.nil?) || (username == "\"\""))
  end

  def is_alphanumeric(username)
  	return username.match(/^[[:alpha:]]+$/)
  end
end
