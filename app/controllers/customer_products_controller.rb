class CustomerProductsController < ApplicationController
  def search
    @products = Product.search("#{params[:search]}").paginate(:per_page=>5,:page=>params[:page])
    
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
