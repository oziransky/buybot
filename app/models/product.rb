#encoding: utf-8
class Product < ActiveRecord::Base
  attr_accessible :name, :description, :url, :catalog_id, :image_folder, :manufacturer, :store_id
  belongs_to :store
  has_and_belongs_to_many :categories

  validates :name, :presence => true
  validates :manufacturer,  :presence => true
  
  
  
  def self.search(search)
    if search
      where("name LIKE ?","%#{search}%")
      #find(:all, :conditions => ['name LIKE ?', "%#{search}%"])
    else
      find(:all)
    end
  end

  def minimum_price
    100+id
  end
end
