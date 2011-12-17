class AuctionStatus < ActiveRecord::Base
  attr_accessible :store_id, :auction_id, :price

  belongs_to :store
  belongs_to :auction

  validates :store_id, :presence => true
  validates :auction_id, :presence => true
end
