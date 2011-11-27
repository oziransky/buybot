class Auction < ActiveRecord::Base
  attr_accessible :product_id, :minimal_step, :maximum_step, :max_num_bids, :current_price

  has_and_belongs_to_many :stores
end
