class Price < ActiveRecord::Base
  include Comparable
  attr_accessible :price, :product_id, :price_id
  belongs_to :product
  belongs_to :store, :dependent => :destroy

  def <=> (other)
    self.price <=> other.price 
  end
end
