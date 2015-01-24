class Beer < ActiveRecord::Base
    include RatingAverage

    belongs_to :brewery
    has_many :ratings, dependent: :destroy

#    def average_rating
#        ratings.average(:score).round(1).to_s
#        #n = ratings.count
#        #s = ratings.map { |r| r.score}.inject (0) { |sum, i| sum + i }
#        #s/n
#    end

    def to_s
    	#"moi! oon olut."
    	"#{name}, from #{brewery.name}"
    end
end
