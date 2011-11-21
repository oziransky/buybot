class Store < ActiveRecord::Base
  attr_accessible :name, :address, :url, :description

  # belongs to a store owner
  belongs_to :store_owner
  # holds many different prices (of products)
  has_many :prices, :dependent => :destroy
  has_many :products, :dependent => :destroy

  validates :name, :presence => true
  validates :url,  :presence => true
end
