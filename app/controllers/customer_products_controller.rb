class CustomerProductsController < ApplicationController
  def search
    @products = Product.search("#{params[:search]}").paginate(:per_page=>5,:page=>params[:page])
    
  end

end
