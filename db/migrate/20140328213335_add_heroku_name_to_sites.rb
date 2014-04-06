class AddHerokuNameToSites < ActiveRecord::Migration
  def change
    add_column :sites, :heroku_name, :string
    add_index :sites, :heroku_name, unique: true
  end
end
