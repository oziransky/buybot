# Background task for sending auction related user emails
class AuctionUserMailJob < Struct.new(:user_id, :auction_id)
  def perform
    auction = Auction.find(auction_id)
    user = User.find(user_id)
    UserMailer.auction_updated(user, auction).deliver
  end
end