class Beer < ActiveRecord::Base
	belongs_to :brewery
    has_many :ratings

    def average_rating
        ratings.average(:score).to_s
        #n = ratings.count
        #s = ratings.map { |r| r.score}.inject (0) { |sum, i| sum + i }
        #s/n
    end
end
