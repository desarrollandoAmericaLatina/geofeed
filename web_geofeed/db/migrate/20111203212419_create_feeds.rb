class CreateFeeds < ActiveRecord::Migration
  def change
    create_table :feeds do |t|
      t.string :university, :null => false
      t.string :address, :null => false
      t.integer :price, :null => false
      t.integer :rank, :null => false
      t.string :career, :null => false
      t.float :latitude, :null => false
      t.float :longitude, :null => false

      t.timestamps
    end
  end
end
