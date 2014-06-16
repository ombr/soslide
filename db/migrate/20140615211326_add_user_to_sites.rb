# AddUserToSites
class AddUserToSites < ActiveRecord::Migration
  # Site.all.each do |site|
  #   site.update user: site.try(:infos).try(:[],:users).try(:first)
  # end
  def change
    add_column :sites, :user, :hstore
  end
end
