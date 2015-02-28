class Membership < ActiveRecord::Base
	belongs_to :user
	belongs_to :beer_club

	#validates :user, :presence => {:if => proc{|o| o.user_id.blank? }}
	#validates :user_id, :presence => {:if => proc{|o| o.user.blank? }}

	validates :user, existence: true
	validates :beer_club, existence: true
	validates_uniqueness_of :user_id, scope: :beer_club_id

	scope :confirmed_memberships, -> { where confirmed:true }
    scope :unconfirmed_memberships, -> { where confirmed:[nil, false] }

    #scope :confirmed_members, -> { where confirmed:true }
    #scope :unconfirmed_members, -> { where confirmed:[nil, false] }

    def to_s
        "#{self.user_id.name}: #{self.beer_club.name}"
    end
end
