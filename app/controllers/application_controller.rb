# encoding: utf-8
class ApplicationController < ActionController::Base
  protect_from_forgery

  layout :layout_by_resource

  def title
    "BuyBot"
  end

  def after_sign_in_path_for(resource)
    stored_location_for(resource) || stores_path
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
end
