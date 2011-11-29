class CategoriesController < ApplicationController

  def index
    @root_categories = Category.top_categories
  end
  def show
    @category = Category.find(params[:id])
    @products = @category.products.paginate(:per_page=>5,:page=>params[:page])
  end
end
