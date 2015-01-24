module RatingAverage
	extend ActiveSupport::Concern
	
    def average_rating
        ratings.average(:score).round(1).to_s
    end
end