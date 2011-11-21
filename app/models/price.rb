class Price < ActiveRecord::Base
  attr_accessible :price, :product_id, :price_id

  belongs_to :store, :dependent => :destroy

end
