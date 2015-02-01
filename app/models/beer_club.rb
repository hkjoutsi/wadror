class BeerClub < ActiveRecord::Base
	has_many :memberships
	has_many :members,-> { uniq }, through: :memberships, source: :user

	validates :name, presence: true

    def to_s
    	if self.city?
    		"#{name}, from #{city}"
    	else
    		"#{name}"
    	end
    end
end
