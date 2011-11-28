class CategoriesController < ApplicationController

  def index
    @root_categories = Category.top_categories
  end
  def show
    @category = Category.find(params[:id])
  end
end
