class Product < ActiveRecord::Base

  PRICE_GRABBER = 0
  SHOPZILLA = 1
  GOOGLE_STORES = 2
  SHOPPING = 3

  attr_accessible :name, :description, :url, :image_folder, :manufacturer,
                  :store_id, :prices_attributes, :categories_attributes, :category_ids

  has_many :prices
  has_many :stores, :through=>:prices, :order=> 'price', :readonly => false
  has_and_belongs_to_many :categories

  accepts_nested_attributes_for :prices, :categories

  validates :name, :presence => true
  validates :manufacturer,  :presence => true

  def self.search(search_params)
    if search_params[:search] != nil
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
    unless products.empty?
      all_prices = products.collect {|p| p.minimum_price}
      [all_prices.min,all_prices.max]
    end

    []
  end

  def self.all_manufacturers(products)
    manufacturers = products.collect {|p| p.manufacturer}
    manufacturers.flatten.uniq
  end

  def minimum_price
    prices.min.price
  end

  def child_of?(category_id)
    return true if (category_ids.include?(category_id))

    for cat in categories do
      ancestors_ids = cat.ancestors.collect {|a| a.id}
      if ancestors_ids.include?(category_id)
        true
      end
    end

    false
  end

  #filters the search result by category and manufacturer. todo-price-ranges
  def self.get_feeds
    ["PRICE_GRABBER", "SHOPZILLA", "GOOGLE_STORES", "SHOPPING"]
  end

  private

  def self.filter(products, filters)
    result = products
    if filters[:categories] != nil and filters[:categories] != ""
      logger.debug "filtering by category id #{filters[:categories]}"
      result = result.find_all{ |product| product.child_of?(filters[:categories].to_i)}
    end
    if filters[:manufacturer] != nil
      logger.debug "filtering by manufacturer #{filters[:manufacturer]}"
      result = result.find_all{|product| product.manufacturer == filters[:manufacturer]}
    end
    if filters[:price_range] != nil
      logger.debug "filtering by price range #{filters[:price_range]}"
      range =filters[:price_range].partition "-"
      result = result.find_all{|product| (product.minimum_price >= range[0].to_f and  product.minimum_price < range[2].to_f)}
    end
    result
  end

end
