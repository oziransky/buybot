class Store < ActiveRecord::Base
  belongs_to :store_owner

  attr_accessible :name, :address, :url, :description

  validates :name, :presence => true
  validates :url,  :presence => true
end
