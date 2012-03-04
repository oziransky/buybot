class CategoriesController < ApplicationController

  def index
    if store_owner_signed_in?
      redirect_to stores_path
    end
  end

  def show
    @category = Category.find(params[:id])
    @products = @category.products.sort!{|p1,p2| p1.minimum_price <=> p2.minimum_price}.paginate(:per_page=>5,:page=>params[:page])
  end
end
