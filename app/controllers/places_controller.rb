class PlacesController < ApplicationController
  before_action :set_place, only: [:show, :edit, :update, :destroy]

  # GET /places
  # GET /places.json
  def index
    @places = Place.all

    oauth_access_token = ENV["ACCESS_TOKEN"]
    @rest = Koala::Facebook::API.new(oauth_access_token)
    # @result = @rest.api("/search?type=place&center=37.76,-122.427&distance=1000")
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

  # GET /places/1
  # GET /places/1.json
  def show
  end

  # GET /places/new
  def new
    @place = Place.new
  end

  # GET /places/1/edit
  def edit
  end

  # POST /places
  # POST /places.json
  def create
    @place = Place.new(place_params)

    respond_to do |format|
      if @place.save
        format.html { redirect_to @place, notice: 'Place was successfully created.' }
        format.json { render :show, status: :created, location: @place }
      else
        format.html { render :new }
        format.json { render json: @place.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /places/1
  # PATCH/PUT /places/1.json
  def update
    respond_to do |format|
      if @place.update(place_params)
        format.html { redirect_to @place, notice: 'Place was successfully updated.' }
        format.json { render :show, status: :ok, location: @place }
      else
        format.html { render :edit }
        format.json { render json: @place.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /places/1
  # DELETE /places/1.json
  def destroy
    @place.destroy
    respond_to do |format|
      format.html { redirect_to places_url, notice: 'Place was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_place
      @place = Place.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def place_params
      params.require(:place).permit(:business, :area)
    end
end
