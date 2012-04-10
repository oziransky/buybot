require 'log4r'
include Log4r

class CustomerProductsController < ApplicationController
  def search
    logger.debug "Performing search for #{params[:search]} in category #{params[:categories]}"
    #@current_search = params[:search]
    search_params = {:search=>params[:search],
					 :categories=>params[:category],
					 :manufacturer=>params[:manufacturer],
					 :price_range=>params[:price_range]}
	  search_result = Product.search(search_params)
    products = search_result.paginate(:per_page=>5,:page=>params[:page])
    prod_categories = Product.all_categories search_result
    manufacturers = Product.all_manufacturers search_result
    @search_results = SearchResults.new products, prod_categories, manufacturers

    #this is an example for extracting Facebook profile. it takes a long time, so it should be
    #used only when needed.
    #@profile = Facebook.profile(current_user.access_token) if user_signed_in?

    if params[:price_range] != ""
      @search_results.price_range=Product.price_range(search_result)
    end



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
