require 'rails_helper'

describe "Places" do
	before :each do
	    #FactoryGirl.create(:brewery, name:brewery_name, year:year+=1)
	    @user = FactoryGirl.create(:user, username:"Pekka")

	    sign_in({username:'Pekka', password:'Foobar1'})

	    visit places_path
	end

	it "if one is returned by the API, it is shown on the page" do
	    #allow(BeermappingApi).to receive(:places_in).with("kumpula").and_return(
	    #  [ Place.new( name:"Oljenkorsi", id: 1 ) ]
	    #)
		bar = FactoryGirl.build(:place, name:"Oljenkorsi")
		allow(BeermappingApi).to receive(:places_in).with("kumpula").and_return(
		[ bar ]
	    )

	    fill_form_with_kumpula
	    save_and_open_page
	    expect(page).to have_content "Oljenkorsi"
  	end

  	it "if none is returned by the API, corresponding message is shown on the page" do
	    allow(BeermappingApi).to receive(:places_in).with("kumpula").and_return(
	      []
	    )
	    fill_form_with_kumpula
	    expect(page).to have_content "No places in kumpula"
  	end

  	it "if many are returned by the API, they are shown on the page" do
  		allow(BeermappingApi).to receive(:places_in).with("kumpula").and_return(
	      FactoryGirl.build_list(:place, 3)
	    )
	    
  		fill_form_with_kumpula

	    expect(page).to have_content "Oljenkorsi0"
	    expect(page).to have_content "Oljenkorsi1"
	    expect(page).to have_content "Oljenkorsi2"
  	end

  	def fill_form_with_kumpula
	    fill_in('city', with: 'kumpula')
	    click_button "Search"
  	end
end