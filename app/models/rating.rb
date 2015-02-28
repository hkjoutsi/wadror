class Rating < ActiveRecord::Base
		
    belongs_to :beer, touch: true
    belongs_to :user #jokainen rating käyttäjäkohtainen

    validates :score, numericality: { greater_than_or_equal_to: 1,
                                    less_than_or_equal_to: 100,
                                    only_integer: true }

    scope :recent, ->(n) { Rating.order(created_at: :desc).first(n) }

    def to_s
        "#{self.beer.name}: #{self.score}p"
    end

    #returns array with [username, user.ratings.count] pairs
    def self.top_raters(n = 3)
    	return nil if n < 1
    	#hash contents: [user_id => nbrOfRatings]
    	raterHash = Rating.group(:user_id).count(:user_id)
    	raterHash.sort_by { |k,v| -v }[0..(n-1)].map { |user_id, rcount| [User.find(user_id).username, rcount] }
    end

    private #aivopieru seuraa alla
    #returns array with [beer.name, beer.average_rating] pairs
    def self.top_beers(n = 3)
    	return nil if n < 1
    	beerHash = Rating.pluck(:beer_id).uniq.inject({}) do |result, beer_id|
	    	beer = Beer.find(beer_id)
	    	result[beer.name] = beer.average_rating
	    	result
    	end #hash contents: [beerName => avgRating]
    	#or
    	#result << {
    	#	beer: Beer.find(beer_id).name,
		#	avg: beer.average_rating
    	#}
    	beerHash.sort_by { |k,v| -v }[0..(n-1)]
    end

        #returns array with [brewery.name, brewery.average_rating] pairs
    def self.top_breweries(n = 3)
    	return nil if n < 1 #or ratings empty ja sama muillekin
    	breweryHash = Rating.pluck(:beer_id).uniq.inject({}) do |result, beer_id|
	    	brewery = Beer.find(beer_id).brewery
	    	result[brewery.name] = brewery.average_rating
	    	result
    	end #hash contents: [beerName => avgRating]
    	breweryHash.sort_by { |k,v| -v }[0..(n-1)]
    end
end
