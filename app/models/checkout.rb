class Checkout < ActiveRecord::Base
  CANCELED = 0
  COMPLETED = 1

  belongs_to :auction

  attr_accessible :final_price, :product_url, :auction_id, :status

  def completed?
    self.status == COMPLETED
  end

  def status_to_s
    if self.status == ACTIVE
      "Completed"
    elsif self.status == PAUSED
      "Canceled"
    end
  end

end
