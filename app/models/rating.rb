class Rating < ActiveRecord::Base
		
    belongs_to :beer
    belongs_to :user #jokainen rating käyttäjäkohtainen

    validates :score, numericality: { greater_than_or_equal_to: 1,
                                    less_than_or_equal_to: 100,
                                    only_integer: true }

    def to_s
        "#{self.beer.name}: #{self.score}p"
    end
end
