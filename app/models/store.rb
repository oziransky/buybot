class Store < ActiveRecord::Base
  attr_accessible :name, :address, :url, :description

  belongs_to :store_owner
  has_many :prices, :dependent => :destroy
  has_many :products, :dependent => :destroy
  has_and_belongs_to_many :auctions

  validates :name, :presence => true
  validates :url,  :presence => true
end
