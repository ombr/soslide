class CreateSites < ActiveRecord::Migration
  def change
    create_table :sites do |t|

      t.timestamps
      t.string :name
      t.string :email
    end
  end
end
