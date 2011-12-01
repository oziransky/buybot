class Store < ActiveRecord::Base
  attr_accessible :name, :address, :url, :description

  belongs_to :store_owner
  has_many :prices, :dependent => :destroy
  has_many :products, :dependent => :destroy

  has_many :auction_statuses
  has_many :auctions, :through => :auction_statuses, :readonly => false

  validates :name, :presence => true
  validates :url,  :presence => true
end
