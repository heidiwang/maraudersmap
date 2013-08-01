require 'open-uri'
require 'rubygems'
require 'json'

class MaraudersmapController < ApplicationController
  def index
   	@url = "https://net-util4001.ecr.box.net:4743/network/wireless_associations.json"
   	@file = open(@url)
   	@contents = @file.read

   	@parsed = JSON.parse(@contents)
   	@locations = Hash.new
    @parsed.each do |item|
    	username = item[1]["username"]
    	@locations[username] = item[1]["ap"]
   	end

  end
end
