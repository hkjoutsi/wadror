class Style < ActiveRecord::Base
	#has_many :beers, dependent: :destroy
	validates :style, uniqueness: true, length: { minimum: 3, maximum: 30 }
	has_many :beers, dependent: :destroy

	def to_s
		style
	end
end
