include ActionView::Helpers::RawOutputHelper

class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :user_facebook
  before_filter :load_categories
  after_filter :user_activity
  layout :layout_by_resource

  def title
    "BuyBot"
  end

  protected

  def layout_by_resource
    if user_signed_in?
      "application"
    elsif store_owner_signed_in?
      "store_owner_application"
    else
      "application"
    end
  end

  def after_sign_in_path_for(resource)
    request.env['omniauth.origin'] || stored_location_for(resource) || root_path
  end

  private

  def load_categories
    @root_categories = @root_categories || Category.top_categories.unshift
  end

  def user_facebook
    if user_signed_in?
      @fb_info = FacebookInfo.find(current_user.id) unless current_user.fb_uid.nil?
    end
  end

  def user_activity
    if user_signed_in?
      current_user.try :touch
      @fb_info = FacebookInfo.find(current_user.id) unless current_user.fb_uid.nil?
    end
  end
end
