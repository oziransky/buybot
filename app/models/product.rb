class Product < ActiveRecord::Base
  attr_accessible :name, :description, :url, :image_folder, :manufacturer,
                  :store_id, :prices_attributes, :categories_attributes, :category_ids

  has_many :prices
  has_many :stores, :through=>:prices, :order=> 'price', :readonly => false
  has_and_belongs_to_many :categories

  accepts_nested_attributes_for :prices, :categories

  validates :name, :presence => true
  validates :manufacturer,  :presence => true
  
  def self.search(search_params)
	logger.debug search_params
	logger.debug search_params[:search]
    if (search_params[:search] != nil)
      logger.debug "the search parameter is " + search_params[:search]
      filter(where("name LIKE ?","%#{search_params[:search]}%"),search_params)
    else
      filter(find(:all),search_params)
    end
  end

  def self.all_categories(products)
    categories = products.collect {|p| p.categories}
    categories.flatten.uniq
  end

  def self.price_range(products)
    all_prices = products.collect {|p| p.prices}
    flat  = all_prices.flatten
    [flat.min.price,flat.max.price]
  end
  
  def self.all_manufacturers(products)
    manufacturers = products.collect {|p| p.manufacturer}
    manufacturers.flatten.uniq
  end
  
  def minimum_price
    prices.min.price
  end
  
  def child_of?(category_id)
	#puts "foo " + product.name + " " +category_id.to_s
    return true if (category_ids.include?(category_id)) 
    for cat in categories do
      ancestors_ids = cat.ancestors.collect {|a| a.id}
        if ancestors_ids.include?(category_id)
          return	true
        end	
    end
    return false
end

#filters the search result by category and manufacturer. todo-price-ranges
private 
  def self.filter(products, filters)
    result = products
    if filters[:categories] != nil and filters[:categories] != ""
      result = result.find_all{ |product| product.child_of?(filters[:categories].to_i)}
      logger.debug result.size
    end
    if filters[:manufacturer] != nil 
      result = result.find_all{|product| product.manufacturer == filters[:manufacturer]}
    end
    if filters[:price_range] != nil
      range =filters[:price_range].partition "_"
      products.each {|p| puts p.minimum_price}
      result = result.find_all{|product| product.minimum_price >= range[0].to_f and  product.minimum_price < range[2].to_f}
    end
    result
  end
  
end
