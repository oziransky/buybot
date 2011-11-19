class CreateProducts < ActiveRecord::Migration
  def self.up
    create_table :products do |t|
      t.string :name
      t.string :description
      t.string :url
      t.integer :catalog_id
      t.string :image_folder
      t.string :manufacturer

      t.timestamps
    end
  end

  def self.down
    drop_table :products
  end
end
