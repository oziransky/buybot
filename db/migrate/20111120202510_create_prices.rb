class CreatePrices < ActiveRecord::Migration
  def self.up
    create_table :prices do |t|
      t.integer :product_id
      t.integer :store_id
      t.float :price

      t.timestamps
    end
    add_index :prices, :product_id
    add_index :prices, :store_id
  end

  def self.down
    drop_table :prices
  end
end
