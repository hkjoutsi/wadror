FactoryGirl.define do
	factory :user do
		sequence(:username, 1000) { |n| "User#{n}" }
		#username "Pekka"
		password "Foobar1"
		password_confirmation "Foobar1"
	end

	factory :rating do
		score 10
	end

	factory :rating2, class: Rating do
		score 20
	end

	factory :brewery do
		name "anonymous"
		year 1900
	end

	factory :beer do
		name "anonymous"
		brewery
		style "Lager"
	end

	factory :place do
		sequence(:name, 0) { |n| "Oljenkorsi#{n}" }
		sequence(:id, 0) { |n| n }
	end	
end