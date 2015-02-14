class AddStyleIdToBeers < ActiveRecord::Migration
  def up
  	#joined = Style.joins('LEFT JOIN beers ON beers.old_style = styles.style')
  	#joined.find_by_style(b.old_style).style
	#Beer.all.each { |b| b.style_id=joined.find_by_style(b.old_style).id }

	Beer.all.each do |b|
		b.style_id=Style.joins('LEFT JOIN beers ON beers.old_style = styles.style').find_by_style(b.old_style).id
		b.save
	end
		
	
  end

  def down
  	Beer.all.each do |b|
  	  b.style_id=nil
  	  b.save
  	end
  end
end
