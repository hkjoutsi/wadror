class FixMigrationByCreatingNewUsersTable < ActiveRecord::Migration
  def up
    #create_table :users do |t|
    #    t.string :username
    #    t.boolean :admin
    #    t.boolean :disabled
    #    t.timestamps null: false
    #end

    #add_column :users, :password_digest, :string

    add_column :users, :disabled, :boolean

  end

  def down
  	#drop_table :users
    remove_column :users, :disabled, :boolean
  end

end
