class AuctionHistory < ActiveRecord::Base
  attr_accessible :product_id, :closed_reason

  serialize :bids
end
