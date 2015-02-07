require 'rails_helper'

describe "Breweries page" do

  	it "should not have any before been created" do
	    visit breweries_path
	    #puts page.html

	    expect(page).to have_content 'Listing breweries'
	    expect(page).to have_content 'Number of breweries: 0'
	end

	describe "when breweries exist" do
		before :each do
			@breweries = ["Koff", "Karjala", "Schlenkerla"]
			year = 1896
			@breweries.each do |brewery_name|
		    	FactoryGirl.create(:brewery, name:brewery_name, year:year+=1)
		    end

		    visit breweries_path
		end
		
		it "lists the existing breweries and their total number" do
			expect(page).to have_content "Number of breweries: #{@breweries.count}"
			#save_and_open_page

		    @breweries.each do |brewery_name|
		      expect(page).to have_content brewery_name
		    end
		end

		it "allows user to navigate to page of a Brewery" do
		    click_link "Koff"
			#save_and_open_page
		    expect(page).to have_content "Koff"
		    expect(page).to have_content "Established in 1897"
		end
	end
end