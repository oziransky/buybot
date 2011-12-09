#encoding: utf-8
class Product < ActiveRecord::Base
  attr_accessible :name, :description, :url, :catalog_id, :image_folder, :manufacturer, :store_id
  has_many :prices
  has_many :stores, :through=>:prices, :order=> 'price'
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
    prices.min.price
  end
  
    
end
