class CreateAuctions < ActiveRecord::Migration
  def self.up
    create_table :auctions do |t|
      t.integer :product_id
      t.string :stores_list
      t.float :minimal_step
      t.float :maximum_step
      t.integer :max_num_bids
      t.float :current_price

      t.timestamps
    end
  end

  def self.down
    drop_table :auctions
  end
end
