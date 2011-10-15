class ApplicationController < ActionController::Base
  protect_from_forgery

  def title
    "BuyBot"
  end
end
