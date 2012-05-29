class Store < ActiveRecord::Base
  attr_accessible :name, :address, :url, :description, :image_path

  belongs_to :store_owner
  # holds many different prices (of products)
  has_many :prices, :dependent => :destroy
  has_many :products, :through=> :prices
  has_many :auction_statuses
  has_many :auctions, :through => :auction_statuses, :readonly => false

  validates :name, :presence => true
  validates :url,  :presence => true

  def product_price (product)
    prices.detect {|p| p.product_id == product.id}.price
  end
end
