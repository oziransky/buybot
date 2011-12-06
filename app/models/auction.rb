class Auction < ActiveRecord::Base
  ACTIVE = 1
  INACTIVE = 0
  PAUSED = 3

  attr_accessible :product_id, :minimal_step, :maximum_step, :max_num_bids, :current_price, :status

  has_many :auction_statuses
  has_many :stores, :through => :auction_statuses, :readonly => false

  def active?
    self.status == ACTIVE
  end

  def auction_status
    if self.status == ACTIVE
      return "פעיל"
    end
    if self.status == INACTIVE
      return "לא פעיל"
    end
    if self.status == PAUSED
      return "מושהה"
    end
  end
end
