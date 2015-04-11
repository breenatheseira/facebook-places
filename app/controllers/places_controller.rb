class PlacesController < ApplicationController

  def index
    @places = Place.all

    oauth_access_token = ENV["ACCESS_TOKEN"]
    @rest = Koala::Facebook::API.new(oauth_access_token)

    lat = params[:lat]
    lng = params[:long]
    distance = params[:distance]

    @query = "/search?type=place&center=" + lat + "," + lng + "&distance=" + distance
    @json_search = @rest.api("#{@query}")
    @data_search = JSON.parse(@json_search.to_json)["data"]   

    @arr = Array.new    

    @data_search.map do |datum|

      @arr << "#{datum["id"]}"

    end

    @pages_info = @rest.get_objects(@arr)

    @loop = Array.new
    @loop << "["
    @pages_info.each do |p| 
      @page = p.last
      
      if @page["category"] == "Restaurant/cafe"

        @loop << ActiveSupport::JSON.encode({
                  id: @page["id"],
                  name: @page["name"],
                  category: @page["category"],
                  description: @page["description"],
                  about: @page["about"],
                  likes: @page["likes"].to_s,
                  website: @page["website"],
                  phone: @page["phone"],
                  link: @page["link"],
                  address: "#{@page["name"]},  #{@page["location"]["street"]}, #{@page["location"]["zip"]}  #{@page["location"]["state"]}, #{@page["location"]["country"]}"
                  })

        @loop << ","
      end
    end
    @loop.pop
    @loop << "]"
  end

  def search
  end

  private
 
end
