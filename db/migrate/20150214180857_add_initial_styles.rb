class AddInitialStyles < ActiveRecord::Migration
  def up
  	#up
  	#Beer.all.select(:style).uniq.each { |s| Style.create style:s.style }
  	Beer.uniq.pluck(:style).each { |s| Style.create style:s }
  end

  def down
  	#remove all styles
  	Style.delete_all
  end
end
