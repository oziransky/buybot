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
    if (search_params["search"] != nil)
      logger.debug "the search parameter is " + search_params["search"]
      filter(where("name LIKE ?","%#{search_params["search"]}%"),search_params)
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
  
  private 
  def self.filter(products, filters)
    result = products
    if filters["categories"] != nil 
        print "filtering categories #{filters["categories"]}"
        result = result.find_all{|product| product.category_ids.include?(filters["categories"])}
    end
    if filters["manufacturers"] != nil 
        print "filtering manufacturers #{filters["manufacturers"]}"
        result = result.find_all{|product| product.manufacturer == filters["manufacturers"]}
    end
    
    result
  end
end
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
  
  private 
  def self.filter(products, filters)
    result = products
    if filters[:categories] != nil
		puts filters
		puts products
		products.each do |p|
			puts p.category_ids
			puts p.manufacturer
		end
        print "filtering categories #{filters[:categories]}"
        result = result.find_all{|product| product.category_ids.include?(filters[:categories].to_i)}
    end
    if filters[:manufacturer] != nil 
        print "filtering manufacturers #{filters[:manufacturer]}"
        result = result.find_all{|product| product.manufacturer == filters[:manufacturer]}
    end
    
    result
  end
end
