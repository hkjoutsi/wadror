class SetAllToActiveInBrewery < ActiveRecord::Migration
  def up
  	Brewery.all.each{ |b| b.active=true; b.save }
  end

  def down
  	Brewery.all.each{ |b| b.active=nil; b.save }
  end

end
