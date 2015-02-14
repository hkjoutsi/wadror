class ChangeStyleColumnsInBeer < ActiveRecord::Migration
  def up
  	rename_column :beers, :style, :old_style
  	add_column :beers, :style_id, :integer, index: true
  end

  def down
  	remove_column :beers, :style_id
  	rename_column :beers, :old_style, :style
  end
end
