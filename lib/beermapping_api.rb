class BeermappingApi
  def self.places_in(city)
    city = city.downcase
    #Rails.cache.fetch(city, expires_in: 5.seconds, race_condition_ttl: 1) { fetch_places_in(city) }
    Rails.cache.fetch(city, expires_in: 1.week, race_condition_ttl: 20) { fetch_places_in(city) }
  end

  def self.fetch_places_in(city)
    #key = "e4884eb5f0f80c2d51da339892368dcc"
    url = "http://beermapping.com/webservice/loccity/#{key}/"
    # tai vaihtoehtoisesti
    # url = 'http://stark-oasis-9187.herokuapp.com/api/'

    response = HTTParty.get "#{url}#{ERB::Util.url_encode(city)}"
    places = response.parsed_response["bmp_locations"]["location"]

    #jos haetulla paikkakunnalla ei ole ravintoloita plauuarvo on hash JA id nil
    return [] if places.is_a?(Hash) and places['id'].nil?
    #jos haetulla paikkakunnalla on vain yksi ravintola on paluuarvo yhden ravintolan hash
    places = [places] if places.is_a?(Hash)
    places.inject([]) do | set, place |
      set << Place.new(place)

    end
  end

  def self.key
    raise "APIKEY env variable not defined" if ENV['APIKEY'].nil?
    ENV['APIKEY']
  end
end