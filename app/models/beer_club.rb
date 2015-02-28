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


    def confirmed_members
        return memberships.confirmed_memberships.map(&:user)
    end

    def unconfirmed_members
        return memberships.unconfirmed_memberships.map(&:user)
    end

end
