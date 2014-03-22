class AddProgressToSites < ActiveRecord::Migration
  def change
    add_column :sites, :status_app, :boolean
    add_column :sites, :status_database, :boolean
    add_column :sites, :status_monitoring, :boolean
    add_column :sites, :status_dns, :boolean
    add_column :sites, :status_domain, :boolean
  end
end
