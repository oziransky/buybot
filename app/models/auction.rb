class Auction < ActiveRecord::Base
  ACTIVE = 1
  INACTIVE = 0
  PAUSED = 3

  attr_accessible :product_id, :minimal_step, :maximum_step, :max_num_bids, :current_price, :status

  has_and_belongs_to_many :stores
end
