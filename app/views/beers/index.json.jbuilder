json.array!(@beers) do |beer|
  #json.extract! beer, :id, :name, :style, :brewery
  #json.url beer_url(beer, format: :json)
  
  json.extract! beer, :id, :name
  json.style do
    json.style beer.style.style
  end
  json.brewery do
    json.name beer.brewery.name
  end

end
