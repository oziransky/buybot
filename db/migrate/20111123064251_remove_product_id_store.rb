class RemoveProductIdStore < ActiveRecord::Migration
  def self.up
    remove_column :stores, :product_id
  end

  def self.down
  end
end
