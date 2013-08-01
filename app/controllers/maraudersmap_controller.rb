require 'open-uri'
require 'rubygems'
require 'json'

class MaraudersmapController < ApplicationController
  def index
   	@url = "https://net-util4001.ecr.box.net:4743/network/wireless_associations.json"
   	@file = open(@url)
   	@contents = @file.read

   	@parsed = JSON.parse(@contents)
   	@users = Hash.new
    @parsed.each do |item|
    	username = item[1]["username"]
    	ap = item[1]["ap"]
    	if ((is_ecr(ap)) && !is_guest(username))
    		@users[username] = ap
    	end
   	end
  end

  private
  def is_ecr(ap_name)
  	echo ap_name
  	return (ap_name.ends_with?(".ecr"))
  end

  def is_guest(username)
  	return (username == "\"\"")
  end
end
