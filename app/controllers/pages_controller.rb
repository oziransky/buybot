class PagesController < ApplicationController

  def home
    @title = t(:home)
  end

  def new_invite
    @title = t(:invite_friends)
  end

  def invite_friends
    email = params[:email]
    message = params[:message]

    # send emails to the invited friend
    Delayed::Job.enqueue(FriendInviteMailJob.new(current_user, email, message))

    flash[:success] = "Invite was successfully sent!"

    redirect_to root_path
  end
end
