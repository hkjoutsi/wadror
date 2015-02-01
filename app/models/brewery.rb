class Brewery < ActiveRecord::Base
    include RatingAverage

	has_many :beers, dependent: :destroy
    has_many :ratings, through: :beers
    validates :name, presence: true
    validates :year, numericality: { only_integer: true,
                                    greater_than_or_equal_to: 1042}
                                    #less_than_or_equal_to: Proc.new{Time.now.year}} #durdurdur not sure if this works?
    validate :year_not_in_the_future


    def print_report
        puts self.name
        puts "established in year #{self.year}"
        puts "number of beers #{self.beers.count}"
    end
    
    def restart
        self.year = 2015
        puts "changed year to #{year}"
    end

    def year_not_in_the_future
        unless year <= Time.now.year
            errors.add(:year, "can't be in the future!")
        end
    end

#    def average_rating
#        ratings.average(:score).round(1).to_s
#    end

end
