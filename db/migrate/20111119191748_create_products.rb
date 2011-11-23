class CreateProducts < ActiveRecord::Migration
  def self.up
    create_table :products do |t|
      t.string :name
      t.string :description
      t.string :url
      t.integer :catalog_id
      t.string :image_folder
      t.string :manufacturer
      t.integer :store_id

      t.timestamps
    end
    add_index :products, :catalog_id
    add_index :products, :store_id
  end

  def self.down
    drop_table :products
  end
end
