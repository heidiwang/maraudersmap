class MaraudersmapController < ApplicationController
  def index
   	url = "https://net-util4001.ecr.box.net:4743/network/wireless_associations.json"
   	file = File.open(url, "rb")
   	@result = file.read
  end
end
