class CreateOperations < ActiveRecord::Migration
  def change
    create_table :operations do |t|
      t.text :logs
      t.string :command
      t.integer :site_id
      t.text :args
      t.timestamps
    end
  end
end
