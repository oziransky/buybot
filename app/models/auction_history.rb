class AuctionHistory < ActiveRecord::Base

  before_create :create_bids

  attr_accessible :product_id, :closed_reason, :bids

  belongs_to :user

  serialize :bids

  def add_bid(store_id, bid)
    self.bids["store_id_#{store_id}"] = bid
  end

  def get_bid(store_id)
    self.bids["store_id_#{store_id}"]
  end

  def has_bid?(store_id)
    not self.bids["store_id_#{store_id}"].nil?
  end

  def get_lowest_bid_store
    store, bid = self.bids.sort_by{ |v| v.last }.first
    store.split("_").last.to_i
  end

private
  def create_bids
    self.bids = Hash.new
  end

end
