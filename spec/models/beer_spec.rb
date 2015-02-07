require 'rails_helper'

RSpec.describe Beer, type: :model do
  #pending "add some examples to (or delete) #{__FILE__}"
  it "is created when a name and style is given " do
	beer = Beer.new name:"Testikalja", style:"lager"
	beer.save
	expect(beer).to be_valid
	expect(Beer.count).to eq(1)
  end
  
  describe "is NOT created when" do
  	
  	it "no name is given" do
  		beer = Beer.create style:"lager"
		expect(beer).to_not be_valid
		expect(Beer.count).to eq(0)
  	end
  	it "no style is given" do
  		beer = Beer.create name:"Testikalja"
		expect(beer).to_not be_valid
		expect(Beer.count).to eq(0)
  	end

  end

end
