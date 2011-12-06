class Product < ActiveRecord::Base
  attr_accessible :name, :description, :url, :catalog_id, :image_folder, :manufacturer, :store_id

  has_and_belongs_to_many :stores
  has_and_belongs_to_many :categories

  validates :name, :presence => true
  validates :manufacturer,  :presence => true
end
