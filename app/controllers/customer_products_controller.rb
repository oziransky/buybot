require 'log4r'
include Log4r

class CustomerProductsController < ApplicationController
  def search
    logger.debug "peforming serach for #{params[:search]} in category #{params[:categories]}"
    search_params = {:search=>params[:search],
					 :categories=>params[:categories],
					 :manufacturer=>params[:manufacturer],
					 :price_range=>params[:price_range]}
	search_results = Product.search(search_params)
    @products = search_results.paginate(:per_page=>5,:page=>params[:page])
    @categories = Product.all_categories search_results
    @manufacturers = Product.all_manufacturers search_results
  end
  
  def show
#    @iiid = params[:productid]
    @product = Product.find(params[:id].to_i)
    
    @stores = @product.stores.uniq.paginate(:per_page=>5,:page=>params[:page])
  end
  
  def start_auction 
    #this code should be moved to auction controller
    @selected_stores = Store.find(params[:selected_store_ids].map {|i| i.to_i})
  end


end
