# Background task for sending auction related user emails
class FriendInviteMailJob < Struct.new(:from, :email, :message)
  def perform
    GeneralMailer.send_friend_invite(from, email, message).deliver
  end
end