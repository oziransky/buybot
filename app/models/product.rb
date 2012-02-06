
require 'log4r'
include Log4r
class Product < ActiveRecord::Base
  attr_accessible :name, :description, :url, :image_folder, :manufacturer, :store_id

  has_many :prices
  has_many :stores, :through=>:prices, :order=> 'price', :readonly => false
  has_and_belongs_to_many :categories
  
  validates :name, :presence => true
  validates :manufacturer,  :presence => true
  
  def self.search(search_params)
	logger.debug search_params
	logger.debug search_params[:search]
    if (search_params[:search] != nil)
      logger.debug "the search parameter is " + search_params[:search]
      filter(where("name LIKE ?","%#{search_params[:search]}%"),search_params)
    else
      find(:all)
    end
  end

  def self.all_categories(products)
    categories = products.collect {|p| p.categories}
    categories.flatten.uniq
  end
  
  def self.all_manufacturers(products)
    manufacturers = products.collect {|p| p.manufacturer}
    manufacturers.flatten.uniq
  end
  
  def minimum_price
    prices.min.price
  end
  
  #filters the search result by category and manufacturer. todo-price-ranges
  private 
  def self.filter(products, filters)
    result = products
    if filters[:categories] != nil
        result = result.find_all{|product| product.category_ids.include?(filters[:categories].to_i)}
    end
    if filters[:manufacturer] != nil 
        result = result.find_all{|product| product.manufacturer == filters[:manufacturer]}
    end
    
    result
  end
end
