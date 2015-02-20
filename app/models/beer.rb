class Beer < ActiveRecord::Base
    include RatingAverage

    belongs_to :brewery
    belongs_to :style
    has_many :ratings, dependent: :destroy
    has_many :raters, -> { uniq }, through: :ratings, source: :user

    validates :name, presence: true
    validates :style, presence: true

#    def average_rating
#        ratings.average(:score).round(1).to_s
#        #n = ratings.count
#        #s = ratings.map { |r| r.score}.inject (0) { |sum, i| sum + i }
#        #s/n
#    end

    def to_s
    	name
    end

    def average
    	# code here
    	# byebug
    	if ratings.count == 0
    		return 0
    	end
    	ratings.map{ |r| r.score}.sum.to_f / ratings.count.to_f
    end

    def self.top(n = 3)
        return nil if n < 1
        beerHash = Beer.all.inject({}) {|result, b| result[b] = b.average_rating; result }
        beerHash.sort_by{ |k,v| -v}[0..(n-1)]
    end

end
