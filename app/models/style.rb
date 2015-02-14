class Style < ActiveRecord::Base
	include RatingAverage

	#has_many :beers, dependent: :destroy
	validates :style, uniqueness: true, length: { minimum: 3, maximum: 30 }
	has_many :beers, dependent: :destroy
	has_many :ratings, through: :beers

	def to_s
		style
	end
end
