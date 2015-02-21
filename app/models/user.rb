class User < ActiveRecord::Base
	include RatingAverage
	
	has_secure_password
	
	has_many :ratings, dependent: :destroy
	has_many :beers, through: :ratings
	has_many :memberships, dependent: :destroy
	has_many :beer_clubs, -> { uniq }, through: :memberships

	validates :username, uniqueness: true, length: { minimum: 3, maximum: 15 }
	#validates :password, length: { minimum: 4}
	validates_format_of :password, :with => /(?=.*[A-Z])(?=.*[\d])(?=.{4,})/, message: "has to contain one number and one upper case letter"#, on: {:create, :edit}
	#validates :password, format: { with: /\d.*[A-Z]|[A-Z].*\d/, message: "has to contain one number and one upper case letter" }

	def to_s
		username
	end
	
	def favorite_beer
		return nil if ratings.count == 0
		#ratings.sort_by{ |r| r.score }.last.beer
		ratings.order(score: :desc).limit(1).first.beer
	end

	#COULD ALSO:
	#return the favorite styles as an array (might be more than one!)
	#same goes for beers, breweries..
	def favorite_style
		return nil if ratings.count == 0
		fav_style_id = ratings.joins(:beer).group("beers.style_id").average("ratings.score").max_by{ |k,v| v }[0]
		Style.find(fav_style_id)
	end

	def favorite_brewery
		return nil if ratings.count == 0
		favorite_brewery_id = ratings.joins(:beer).group("beers.brewery_id").average("ratings.score").max_by{ |k,v| v }[0]
		Brewery.find(favorite_brewery_id)
	end

	#below more generic functions

	def favorite(category)
	    return nil if ratings.empty?
	    if category == :beer
	    	favorite_beer
	    else
		    category_ratings = rated(category).inject([]) do |set, item|
		      set << {
		        item: item,
		        rating: rating_of(category, item) }
		    end

		    category_ratings.sort_by { |item| item[:rating] }.last[:item]
		end
	end

  	#e.g. category: :brewery, item: koff (where koff an object)
  	def rating_of(category, item)
	    ratings_of_item = ratings.select do |r|
	    	r.beer.send(category) == item
	    end
    	unless ratings_of_item.count == 0
    		ratings_of_item.map(&:score).sum / ratings_of_item.count
    	else
    		0
    	end
  	end

	#category: :brewery, :style...
	def rated(category)
    	ratings.map{ |r| r.beer.send(category) }.uniq
  	end
end
