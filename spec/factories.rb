FactoryGirl.define do
	factory :user do
		sequence(:username, 1000) { |n| "User#{n}" }
		#username "Pekka"
		password "Foobar1"
		password_confirmation "Foobar1"
		admin false
	end

	factory :pasi, class: User do
		sequence(:username, 1) { |n| "pasi#{n}"}
		password "Foobar1"
		password_confirmation "Foobar1"
		admin false
	end

	factory :brewery do
		name "anonymous"
		year 1900
		active true
	end

	factory :style do
		sequence(:style, 0) { |n| "Lager#{n}" }
		description "is very nice"
	end

	factory :beer do
		#sequence(:name, 0) { |n| "Kalja#{n}" }
		name "kalja"
		brewery
		style
	end

	factory :rating do
		score 10
		user
		beer
	end

	factory :rating2, class: Rating do
		score 20
	end

	factory :place do
		sequence(:name, 0) { |n| "Oljenkorsi#{n}" }
		sequence(:id, 0) { |n| n }
	end	
end