# encoding: utf-8
class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :load_categories
  layout :layout_by_resource

  def title
    "BuyBot"
  end

  protected

  def layout_by_resource
    if store_owner_signed_in?
      "store_owner_application"
    else
      if devise_controller?
        "store_owner_application"
      else
        "application"
      end
    end
  end

  private

  def load_categories
    @root_categories = @root_categories || Category.top_categories.unshift
  end

end
