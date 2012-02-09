require 'log4r'
include Log4r

class CustomerProductsController < ApplicationController
  def search
    logger.debug 'hello'
    logger.debug "Performing search for #{params[:search]} in category #{params[:categories]}"
    @current_search = params[:search]
    @products = Product.search("#{params[:search]}").paginate(:per_page=>5,:page=>params[:page])
    @categories = Product.all_categories @products
    @manufacturers = Product.all_manufacturers @products
  end
  
  def show
    @product = Product.find(params[:id].to_i)
    
    @stores = @product.stores.uniq.paginate(:per_page=>5,:page=>params[:page])
  end
  
  def start_auction 
    # TODO: this code should be moved to auction controller
    @selected_stores = Store.find(params[:selected_store_ids].map {|i| i.to_i})
  end

end
