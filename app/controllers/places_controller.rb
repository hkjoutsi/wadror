class PlacesController < ApplicationController
  def index
  end

  def show
    #byebug
    @place = Rails.cache.read(session[:last_city].downcase).detect{ |p| p.id==params[:id] }
    if @place.nil? # or @place.empty?
      redirect_to places_path, :notice => "Woops, that place doesn't exist?"
    else 
      @mapURL = map_url(@place.name, @place.city, @place.country)
      render :show
    end
  end

  def search
  	@places = BeermappingApi.places_in(params[:city])

    #tallennetaan tulokset sessioon
    session[:last_city] = params[:city]

  	if @places.empty?
		  redirect_to places_path, :notice => "No places in #{params[:city]}"
    else
		  render :index
    end
  end

  private
  def map_url(place_name, city, country)
  
    #key = "AIzaSyCVK7CXD7aPEeqrFaYGmsYJst2ik3wbAZc"
    raise "maps_APIKEY env variable not defined" if ENV['maps_APIKEY'].nil?
    key = ENV['maps_APIKEY']
    url = "https://www.google.com/maps/embed/v1/place?key=#{key}&q="
    url << ERB::Util.url_encode(place_name + city + country)
  end

  

end