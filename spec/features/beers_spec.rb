require 'rails_helper'

describe "Beers page" do

	describe "when beers exist" do
		before :each do
			@beers = ["Iso 3", "Karhu"]
			style = "Lager"
			brewery = FactoryGirl.create(:brewery, name:"Koff")
			@beers.each do |beer_name|
		    	FactoryGirl.create(:beer, name:beer_name, style:style, brewery:brewery)
		    end

		    visit beers_path
		end

	  	it "should list all created beers" do
		    #puts page.html

		    expect(page).to have_content 'Listing beers'
		    expect(page).to have_content 'Iso 3'
		    expect(page).to have_content 'Karhu'
		    expect(page).to have_content 'Koff'
		end
		
		it "allows user to navigate to page of the beer" do
		    click_link "Iso 3"
			#save_and_open_page
		    expect(page).to have_content "Name: Iso 3"
		    expect(page).to have_content "Style: Lager"
		    expect(page).to have_content "Brewery: Koff"
		end
	end

	describe "when creating a new beer" do
		let!(:brewery) { FactoryGirl.create :brewery, name:"Koff" }
		before :each do
			visit new_beer_path
		end

		describe "with a valid name" do

		  	it "it is created and browser redirects to the beer's page" do
				#save_and_open_page
				fill_in('beer[name]', with:"Iso 3")
				select('Lager', from:'beer[style]')
				select('Koff', from:'beer[brewery_id]')

			    expect{
			      click_button "Create Beer"
			    }.to change{Beer.count}.from(0).to(1)

			    expect(brewery.beers.count).to eq(1)

			    expect(current_path).to eq(beer_path(Beer.first))
      			expect(page).to have_content 'Iso 3'
			end

			it "it is NOT created and browser redirects to the new beer page" do
				#save_and_open_page
				fill_in('beer[name]', with:"")
				select('Lager', from:'beer[style]')
				select('Koff', from:'beer[brewery_id]')

			    click_button "Create Beer"
			    
			    #save_and_open_page

			    expect(Beer.count).to eq(0)
			    expect(brewery.beers.count).to eq(0)

			    expect(current_path).to eq(beers_path) #koska POST beersiin
      			expect(page).to have_content "Name can't be blank"
      			expect(page).to have_content "New beer"
			end
			
		end
	end

end