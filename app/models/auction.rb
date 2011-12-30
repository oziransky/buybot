class Auction < ActiveRecord::Base

  CANCELED = 0    # stopped - canceled
  ACTIVE = 1      # running
  SOLD = 2        # stopped - product sold
  PAUSED = 3      # user has suspended the auction
  TIMEOUT = 4     # stopped - due to timeout

  DEFAULT_TIME = 10 * 60 # default time is 10 minutes

  attr_accessible :product_id, :minimal_step, :maximum_step, :max_num_bids, :current_price, :status

  has_many :auction_statuses
  has_many :stores, :through => :auction_statuses, :readonly => false

  def active?
    self.status == ACTIVE
  end

  def auction_status
    if self.status == ACTIVE
      return "Active"
    end
    if self.status == PAUSED
      return "Paused"
    end
  end
end
