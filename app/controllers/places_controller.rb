class PlacesController < ApplicationController

  def index
    @places = Place.all

    oauth_access_token = ENV["ACCESS_TOKEN"]
    @rest = Koala::Facebook::API.new(oauth_access_token)

    @json_search = @rest.api("/search?type=place&center=37.76,-122.427&distance=1000")
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
    @loop.pop
    @loop << "]"
  end

  def search
  end

  private
 
end
