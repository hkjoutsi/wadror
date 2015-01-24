class Brewery < ActiveRecord::Base
    include RatingAverage

	has_many :beers, dependent: :destroy
    has_many :ratings, through: :beers

    def print_report
        puts self.name
        puts "established in year #{self.year}"
        puts "number of beers #{self.beers.count}"
    end
    
    def restart
        self.year = 2015
        puts "changed year to #{year}"
    end

#    def average_rating
#        ratings.average(:score).round(1).to_s
#    end

end
