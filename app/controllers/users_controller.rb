class UsersController < ApplicationController
  def connect_to_fb
    client = Facebook.app

    # redirect user to facebook
    redirect_to client.authorization_uri(:scope => Facebook.scope)
  end

  def authenticate_fb
    client = Facebook.app

    client.authorization_code = params[:code]
    access_token = client.access_token! :client_auth_body

    fb_user = Facebook.profile access_token

    user = User.find_or_create(fb_user)

    sign_in_and_redirect user

    flash[:success] = t(:connected_to_facebook)

    Delayed::Job.enqueue(FacebookReaderJob.new(user.id))
  end

  def destroy
    sign_out current_user

    flash[:success] = t(:logged_out)

    redirect_to (:back)
  end
end
