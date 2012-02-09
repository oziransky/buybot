class CategoriesController < ApplicationController

  def index
    #@root_categories = Category.top_categories
  end

  def show
    @category = Category.find(params[:id])
    @products = @category.products.sort!{|p1,p2| p1.minimum_price <=> p2.minimum_price}.paginate(:per_page=>5,:page=>params[:page])
  end
end
