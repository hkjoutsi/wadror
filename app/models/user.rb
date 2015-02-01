class User < ActiveRecord::Base
	include RatingAverage
	
	has_secure_password
	
	has_many :ratings, dependent: :destroy
	has_many :beers, through: :ratings
	has_many :memberships, dependent: :destroy
	has_many :beer_clubs, -> { uniq }, through: :memberships

	validates :username, uniqueness: true, length: { minimum: 3, maximum: 15 }
	#validates :password, length: { minimum: 4}
	validates_format_of :password, :with => /(?=.*[A-Z])(?=.*[\d])(?=.{4,})/#, on: {:create, :edit}

end