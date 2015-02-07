require 'rails_helper'
#include OwnTestHelper

describe "Rating" do
  let!(:brewery) { FactoryGirl.create :brewery, name:"Koff" }
  let!(:beer1) { FactoryGirl.create :beer, name:"iso 3", brewery:brewery }
  let!(:beer2) { FactoryGirl.create :beer, name:"Karhu", brewery:brewery }
  let!(:user) { FactoryGirl.create :user }

  before :each do
    sign_in({username:'User1000', password:'Foobar1'})
    #visit signin_path
    #fill_in('username', with:user.username)
    #fill_in('password', with:'Foobar1')
    #click_button('Log in')
  end

  it "when given, is registered to the beer and user who is signed in" do
    visit new_rating_path
    select('iso 3', from:'rating[beer_id]')
    fill_in('rating[score]', with:'15')

    expect{
      click_button "Create Rating"
    }.to change{Rating.count}.from(0).to(1)

    expect(user.ratings.count).to eq(1)
    expect(beer1.ratings.count).to eq(1)
    expect(beer1.average_rating).to eq(15.0)
  end

  it "All raitings are showed on the ratings index page" do
    ratings = [1, 10, 100]
    create_beers_with_ratings(ratings, user, brewery)

    visit ratings_path

    #save_and_open_page

    expect(Rating.all.count).to eq(3)
    expect(user.ratings.count).to eq(3)
    
    expect(page).to have_content "anonymous: 1p"
    expect(page).to have_content "anonymous: 10p"
    expect(page).to have_content "anonymous: 100p"

    expect(page).to have_content "Count of ratings: 3"

  end

    def create_beer_with_rating(score, user, brewery = FactoryGirl.create(:brewery))
      beer = FactoryGirl.create(:beer, brewery:brewery)
      FactoryGirl.create(:rating, score:score, beer:beer, user:user)

      beer
    end

    #scores - array with scores, brewery parameter optional
    #tried with *scores and optional brewery but resulted in errors
    def create_beers_with_ratings(scores, user, brewery = FactoryGirl.create(:brewery))
      scores.each do |score|
        create_beer_with_rating(score, user, brewery)
      end
    end

end
