class AddInfosToSites < ActiveRecord::Migration
  def change
    add_column :sites, :pages, :integer
    add_column :sites, :images, :integer
    add_column :sites, :infos, :text
  end
end
