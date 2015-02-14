require 'rails_helper'

#describe User do

#end


RSpec.describe User, type: :model do
#  pending "add some examples to (or delete) #{__FILE__}"
	it "has the username set correctly" do
		user = User.new username:"Pekka"

		#user.username.should == "Pekka"
		expect(user.username).to eq("Pekka")
	end

	it "is not saved without a password" do
		user = User.create username:"Pekka"

		#expect(user.valid?).to be(false)
		expect(user).not_to be_valid
		expect(User.count).to eq(0)
	end

	describe "with a proper password" do
		#let(:user){User.create username:"Pekka", password:"Secret1", password_confirmation:"Secret1"}
		let(:user){ FactoryGirl.create(:user) }
		
		it "is saved" do
			expect(user.valid?).to be(true)
			expect(User.count).to eq(1)
		end

		it "and with two ratings, has the correct average rating" do
		    #rating = Rating.new score:10
		    #rating2 = Rating.new score:20

		    #user.ratings << rating
		    #user.ratings << rating2

		    user.ratings << FactoryGirl.create(:rating)
		    user.ratings << FactoryGirl.create(:rating2)

		    expect(user.ratings.count).to eq(2)
		    expect(user.average_rating).to eq(15.0)
	  	end
  	end

  	it "is not saved with a password too short" do
  		user = User.create username:"Pekka", password:"Se1", password_confirmation:"Se1"
  		expect(user).not_to be_valid
		expect(User.count).to eq(0)
  	end
  	it "is not saved with a password without digits" do
  		user = User.create username:"Pekka", password:"Saaaaaa", password_confirmation:"Saaaaaa"
  		expect(user).not_to be_valid
		expect(User.count).to eq(0)
  	end

  	describe "favorite beer" do
		let(:user){ user = FactoryGirl.create(:user) }

	  	it "has a method for determining the favorite_beer" do
	  		expect(user).to respond_to(:favorite_beer)
	  	end

	  	it "without ratings does not have one" do
	  		expect(user.favorite_beer).to eq(nil)
	  	end

	  	it "when only one rating done, is the only beer rated" do
	  		beer = create_beer_with_rating(10, user)
			
	  		expect(user.favorite_beer).to eq(beer)
	  	end

	  	it "is the one with highest rating if several rated" do
			best = create_beer_with_rating(45, user)
			create_beers_with_ratings([10, 20, 15, 7, 9], user)
	  		
	  		expect(user.favorite_beer).to eq(best)
	  	end
  	end

  	describe "favorite style" do
  		let!(:user){ user = FactoryGirl.create(:user) }

  		it "has a method for determining the favorite_style" do
  			expect(user).to respond_to(:favorite_style)
  		end

  		it "without rated beers does not have one" do
  			expect(user.favorite_style).to eq(nil)
  		end

	  	it "when only one rating done, is the style of that beer" do
	  		beer = create_beer_with_rating(10, user)
	  		
	  		expect(user.favorite_style).to eq(beer.style)
	  	end
  		describe "with multiple ratings" do
  			
  			let!(:style1){ style1 = FactoryGirl.create(:style, style:"IPA") }
			let!(:lager){ lager = FactoryGirl.create(:style, style:"Lager") }
			let!(:porter){ porter = FactoryGirl.create(:style, style:"Porter") }
			#before :each do
			#IPA = FactoryGirl.create(:style, style:"IPA") 
			#lager = FactoryGirl.create(:style, style:"Lager") 
			#porter = FactoryGirl.create(:style, style:"Porter") 
	  		#end
		  	it "is the style with highest AVERAGE rating if several beers rated" do
		  		best = create_beer_with_rating_and_style(style1, 50, user)
		  		create_beer_with_rating_and_style(lager , 10, user)
		  		create_beer_with_rating_and_style(porter, 35, user)
		  		create_beer_with_rating_and_style(porter, 35, user)
		  		
		  		expect(user.favorite_style).to eq(best.style)
		  	end

		  	it "TESTES THE HELPER FUNCTION IN THIS TEST CLASS -> is the style with highest average rating if several beers rated" do
		  		stylesAndScoresHash = { style1 => [50], lager => [10, 45], porter => [5, 28]}
		  		create_beers_with_ratings_and_styles(stylesAndScoresHash, user)
		  		
		  		expect(user.favorite_style).to eq(style1)
		  	end
	  	end
  	end

  	describe "favorite brewery" do
		let(:user){ user = FactoryGirl.create(:user) }
  		
  		it "has a method for determining the favorite_brewery" do
  			expect(user).to respond_to(:favorite_brewery)
  		end

  		it "without rated beers does not have one" do
  			expect(user.favorite_brewery).to eq(nil)
  		end

	  	it "when only one rating done, is the brewery of that beer" do
	  		beer = create_beer_with_rating(10, user)
	  		
	  		expect(user.favorite_brewery).to eq(beer.brewery)
	  	end

	  	it "is the brewery with highest average rating if several beers rated" do
	  		koff = FactoryGirl.create(:brewery, name:"Koff")
	  		brewdog = FactoryGirl.create(:brewery, name:"BrewDog")

	  		#create_beer_with_rating(50, user, koff)
	  		#create_beer_with_rating(50, user, koff)
	  		#fav = create_beer_with_rating(60, user, brewdog)

	  		create_beers_with_ratings([50, 50, 40], user, koff)
	  		create_beers_with_ratings([60], user, brewdog)
	  		fav = brewdog

	  		expect(user.favorite_brewery).to eq(fav)
	  		#create_beer_with_rating_and_style("IPA", 50, user)
	  		#create_beer_with_rating_and_style("Lager", 10, user)
	  		#create_beer_with_rating_and_style("Porter", 20, user)
	  		#best = create_beer_with_rating_and_style("Porter", 35, user)
	  		
	  		#expect(user.favorite_style).to eq(best.style)
	  	end 		
  	end

  	def create_beer_with_rating(score, user, brewery = FactoryGirl.create(:brewery), style = FactoryGirl.create(:style))
  		beer = FactoryGirl.create(:beer, brewery:brewery, style:style)
  		FactoryGirl.create(:rating, score:score, beer:beer, user:user)

  		beer
  	end

  	#scores - array with scores, brewery parameter optional
  	#tried with *scores and optional brewery but resulted in errors
  	def create_beers_with_ratings(scores, user, brewery = FactoryGirl.create(:brewery), style = FactoryGirl.create(:style))
  		scores.each do |score|
  			create_beer_with_rating(score, user, brewery, style)
  		end
  	end

  	def create_beer_with_rating_and_style(style, score, user)
  		beer = FactoryGirl.create(:beer, style:style)
  		FactoryGirl.create(:rating, score:score, beer:beer, user:user)
  		beer
  	end

  	#hash with Style => [rating1, rating2...]?
  	def create_beers_with_ratings_and_styles(stylesAndScoresHash, user)
  		stylesAndScoresHash.each do |style, scoreArray|
  			#byebug
  			scoreArray.each do |score|
				create_beer_with_rating_and_style(style, score, user)
			end
  		end
  	end
end
