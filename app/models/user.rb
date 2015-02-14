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

	def favorite_beer
		return nil if ratings.count == 0
		#return ratings.first.beer if ratings.count == 1
		#ratings.sort_by{ |r| r.score }.last.beer
		ratings.order(score: :desc).limit(1).first.beer
	end

	#WOULD BE BETTER IF
	#returns the favorite styles as an array (might be more than one!)
	#same goes for beers, breweries.. LATER. dydy.
	#modify tests accordingly if changed later to ^
	def favorite_style
		return nil if ratings.count == 0
		fav_style_id = ratings.joins(:beer).group("beers.style_id").average("ratings.score").max_by{ |k,v| v }[0]
		Style.find(fav_style_id)
		
		#return ratings.first.beer.style if ratings.count == 1
		#if coming here, ratings.count > 1
		#u.ratings.joins(:beer).group("beers.style").sum("ratings.score")
		#^ use that!
		#hash.max_by{|k,v| v} #assuming doesn't matter if multiple styles with same scoresum
		#stylesAndScores = ratings.joins(:beer).group("beers.style").sum("ratings.score")
		#maxKey = stylesAndScores.max_by{ |k,v| v }[0] #[k, v] array
		#each { |k, v| puts k if v == hash.values.max }
		#maxValue = stylesAndScores.values.max
		#favorite_styles = stylesAndScores.select{ |k, v| stylesAndScores[k] == maxValue }
		#return favorite_styles.keys
	end

	def favorite_brewery
		return nil if ratings.count == 0
		#return ratings.first.beer.brewery if ratings.count == 1
		favorite_brewery_id = ratings.joins(:beer).group("beers.brewery_id").average("ratings.score").max_by{ |k,v| v }[0]
		Brewery.find(favorite_brewery_id)
	end
end
