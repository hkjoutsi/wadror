class Style < ActiveRecord::Base
	#has_many :beers, dependent: :destroy
	validates :style, uniqueness: true, length: { minimum: 3, maximum: 30 }
end
