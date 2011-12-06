class CustomerProductsController < ApplicationController
  def search
    @products = Product.search("#{params[:search]}").paginate(:per_page=>5,:page=>params[:page])
    
  end
  
  def show
#    @iiid = params[:productid]
    @product = Product.find(params[:productid])
    
    @stores = @product.stores.paginate(:per_page=>5,:page=>params[:page])
  end

end
