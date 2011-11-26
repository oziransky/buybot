class CategoriesController < ApplicationController

  def index
    @root_categories = Category.top_categories
  end
end
