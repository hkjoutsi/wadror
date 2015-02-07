require 'rails_helper'

describe "User" do
  before :each do
    #FactoryGirl.create(:brewery, name:brewery_name, year:year+=1)
    @user = FactoryGirl.create(:user, username:"Pekka")
  end

  describe "who has signed up" do
    it "can signin with right credentials" do
      #visit signin_path
      #fill_in('username', with:'Pekka')
      #fill_in('password', with:'Foobar1')
      #click_button('Log in')
      #puts @user.username    
      #save_and_open_page
      #puts page.html
      sign_in({username:'Pekka', password:'Foobar1'})

      expect(page).to have_content 'Welcome back!'
      expect(page).to have_content 'Pekka'
    end

    it "is redirected back to signin form if wrong credentials given" do
      #visit signin_path
      #fill_in('username', with:'Pekka')
      #fill_in('password', with:'wrong')
      #click_button('Log in')
      sign_in({username:'Pekka', password:'wrong'})

      expect(current_path).to eq(signin_path)
      expect(page).to have_content 'User Pekka does not exist OR you gave the wrong password!'
    end

    it "when signed up with good credentials, is added to the system" do
      visit signup_path
      fill_in('user_username', with:'Brian')
      fill_in('user_password', with:'Secret55')
      fill_in('user_password_confirmation', with:'Secret55')

      expect{
        click_button('Create User')
      }.to change{User.count}.by(1)
    end

  end

  describe "on the user's page" do
    let!(:beer1){ FactoryGirl.create :beer, name:"Beer1" }
    let!(:beer2){ FactoryGirl.create :beer, name:"Beer2" }
    let!(:rating1){ FactoryGirl.create(:rating, beer:beer1, score:10, user:@user) }
    let!(:rating2){ FactoryGirl.create(:rating, beer:beer2, score:20, user:@user) }

    before :each do
      sign_in({username:'Pekka', password:'Foobar1'})
    end

    it "shows users favorite beer" do
      visit user_path(@user)
      expect(page).to have_content 'Favorite beer: Beer2'
      #save_and_open_page
    end

    it "shows users favorite style" do
      expect(page).to have_content 'Favorite style: Lager'
    end

    it "shows users favorite brewert" do
      expect(page).to have_content 'Favorite brewery: anonymous'
    end

    it "shows only ratings done by user" do
      FactoryGirl.create(:rating, beer:beer1, score:100, user:(FactoryGirl.create :user))
      
      visit user_path(@user)
      #save_and_open_page
      
      expect(page).to have_content 'Beer1: 10p'
      expect(page).to have_content 'Beer2: 20p'
      
      expect(page).to_not have_content 'anonymous: 100p'

    end

    describe "when deleting a rating" do
      it "it is removed from the page and db" do
        #save_and_open_page
        #expect{
         # click_button('delete')
         # }.to change{User.count}.by(1)
        visit user_path(@user)
        expect{
          page.find('li', :text => 'Beer1').click_link('delete')
          }.to change{@user.ratings.count}.from(2).to(1)
        expect(Rating.count).to eq(1)
        expect(@user.beers.count).to eq(1)

        expect(page).to_not have_content 'Beer1: 10p'
        expect(page).to have_content 'Beer2: 20p'
        
        #save_and_open_page        

      end
    end

  end
end