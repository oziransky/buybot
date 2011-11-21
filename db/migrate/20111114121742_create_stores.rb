class CreateStores < ActiveRecord::Migration
  def self.up
    create_table :stores do |t|
      t.string :name
      t.string :address
      t.string :url
      t.string :description
      t.integer :store_owner

      t.timestamps
    end
    add_index :stores, :store_owner
  end

  def self.down
    drop_table :stores
  end
end
