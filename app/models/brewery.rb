class Brewery < ActiveRecord::Base
    include RatingAverage

	has_many :beers, dependent: :destroy
    has_many :ratings, through: :beers

    validates :name, presence: true
    validates :year, numericality: { only_integer: true,
                                     greater_than_or_equal_to: 1024,
                                     less_than_or_equal_to: ->(_) { Time.now.year } }
                                    #less_than_or_equal_to: Proc.new{Time.now.year}} #durdurdur not sure if this works?
    #validate :year_not_in_the_future

    scope :active, -> { where active:true }
    scope :retired, -> { where active:[nil, false] }


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

    def to_s
        #"moi! oon panimo."
        name
    end

    def self.top(n = 3)
        return nil if n < 1
        breweryHash = Brewery.all.inject({}) {|result, b| result[b] = b.average_rating; result }
        breweryHash.sort_by{ |k,v| -v}[0..(n-1)]
    end

end
