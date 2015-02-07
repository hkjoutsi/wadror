module RatingAverage
	extend ActiveSupport::Concern
	
    def average_rating
    	if ratings.count == 0
    		return 0
    	end
        #ratings.average(:score).round(1).to_s
        ratings.average(:score).round(1)
    end
end