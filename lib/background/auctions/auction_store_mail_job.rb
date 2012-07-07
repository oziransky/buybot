# Background task for sending auction related store owner emails
class AuctionStoreMailJob < Struct.new(:store_owner, :auction, :mail_action)
  def perform
    if mail_action == StoreOwnerMailer::STARTED
      StoreOwnerMailer.auction_started(store_owner, auction).deliver
    elsif mail_action == StoreOwnerMailer::UPDATED
      StoreOwnerMailer.auction_updated(store_owner, auction).deliver
    elsif mail_action == StoreOwnerMailer::DROPPED
      StoreOwnerMailer.store_dropped(store_owner, auction).deliver
    end
  end
end