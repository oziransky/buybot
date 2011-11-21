class Product < ActiveRecord::Base
  attr_accessible :name, :description, :url, :catalog_id, :image_folder, :manufacturer, :price_id
  belongs_to :store

  validates :name, :presence => true
  validates :manufacturer,  :presence => true
end
