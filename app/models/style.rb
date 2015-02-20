class Style < ActiveRecord::Base
	include RatingAverage

	#has_many :beers, dependent: :destroy
	validates :style, uniqueness: true, length: { minimum: 3, maximum: 30 }
	has_many :beers, dependent: :destroy
	has_many :ratings, through: :beers

	def to_s
		style
	end

	def self.top(n=3)
        return nil if n < 1
        styleHash = Style.all.inject({}) {|result, b| result[b] = b.average_rating; result }
        styleHash.sort_by{ |k,v| -v}[0..(n-1)]
	end

end
