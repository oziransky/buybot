class Price < ActiveRecord::Base
  include Comparable

  attr_accessible :price, :product_id, :price_id, :store_id

  belongs_to :product
  belongs_to :store, :dependent => :destroy

  validates :price, :numericality=>{:greater_than_or_equal_to=>0.0}

  def <=> (other)
    self.price <=> other.price
  end
end
