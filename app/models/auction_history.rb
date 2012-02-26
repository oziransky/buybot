class AuctionHistory < ActiveRecord::Base
  attr_accessible :product_id, :closed_reason, :user_id

  serialize :bids
  belongs_to :user

end
