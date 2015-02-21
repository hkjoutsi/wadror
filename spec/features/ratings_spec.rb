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

  it "Three best beers are showed on the ratings index page" do
    ratings = [8, 10, 20, 100]
    create_beers_with_ratings(ratings, user, brewery)

    visit ratings_path

    expect(Rating.all.count).to eq(4)
    expect(user.ratings.count).to eq(4)

    expect(page).to have_content "Best beers"

    expect(page).to have_content "kalja 10"
    expect(page).to have_content "kalja 20"
    expect(page).to have_content "kalja 100"
    expect(page).to_not have_content "kalja 8"

    expect(page).to have_content "Total ratings: 4"

  end

  it "Three best breweries are showed on the ratings index page" do
    create_beer_with_rating(2, user)
    create_beer_with_rating(50, user)
    create_beer_with_rating(90, user)
    create_beer_with_rating(100, user)

    visit ratings_path

    expect(Rating.all.count).to eq(4)
    expect(user.ratings.count).to eq(4)

    expect(page).to have_content "Best breweries"

    expect(page).to have_content "anonymous 100"
    expect(page).to have_content "anonymous 90"
    expect(page).to have_content "anonymous 50"
    expect(page).to_not have_content "anonymous 2"

    expect(page).to have_content "Total ratings: 4"

  end

  it "Three most active raters(users) are showed on the ratings index page" do
    userList = FactoryGirl.create_list(:pasi, 4)
    FactoryGirl.create_list(:rating, 5, user:userList[0])
    FactoryGirl.create_list(:rating, 4, user:userList[1])
    FactoryGirl.create_list(:rating, 3, user:userList[2])
    FactoryGirl.create_list(:rating, 2, user:userList[3])
#    FactoryGirl.create_list(:rating, 5, user:user)

    visit ratings_path
    #save_and_open_page

    expect(Rating.all.count).to eq(14)
    expect(userList[0].ratings.count).to eq(5)

    expect(page).to have_content "Most active raters"

    expect(page).to have_content "pasi1 5"
    expect(page).to have_content "pasi2 4"
    expect(page).to have_content "pasi3 3"
    expect(page).to_not have_content "pasi4 2"

    expect(page).to have_content "Total ratings: 14"

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

