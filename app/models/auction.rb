# encoding: utf-8

class Auction < ActiveRecord::Base

  CANCELED = 0    # stopped - canceled
  ACTIVE = 1      # running
  SOLD = 2        # stopped - product sold
  PAUSED = 3      # user has suspended the auction
  TIMEOUT = 4     # stopped - due to timeout
  CHECKOUT = 5    # stopped - in checkouts process

  DEFAULT_TIME = 5 * 60 # default time is 10 minutes

  #attr_accessible :product_id, :minimal_step, :maximum_step, :max_num_bids, :current_price, :status, :close_at
  attr_accessible :product_id, :current_price, :status, :close_at, :user_id, :bids_received

  has_many :auction_statuses
  has_many :stores, :through => :auction_statuses, :readonly => false
  has_one :checkout, :dependent => :destroy

  def active?
    self.status == ACTIVE
  end

  def in_processing?
    self.status == TIMEOUT || self.status == CHECKOUT || self.status == SOLD
  end

  def status_to_s
    if self.status == ACTIVE
      "Active"
    elsif self.status == PAUSED
      "Paused"
    elsif self.status == CANCELED
      "Canceled"
    elsif self.status == SOLD
      "Sold"
    elsif self.status == TIMEOUT
      "Timeout"
    elsif self.status == CHECKOUT
      "Checkout Process"
    end
  end
end
