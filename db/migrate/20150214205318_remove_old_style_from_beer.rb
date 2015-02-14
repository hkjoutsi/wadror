class RemoveOldStyleFromBeer < ActiveRecord::Migration
  def up
  	remove_column :beers, :old_style
  end

  def down
  	add_column :beers, :old_style, :string
  	Beer.all.each do |b|
  		b.old_style = Style.find(b.style_id).style
  		b.save
  	end
  end
end
