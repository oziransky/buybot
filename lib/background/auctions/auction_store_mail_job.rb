# Background task for sending auction related store owner emails
class AuctionStoreMailJob < Struct.new(:auction_id, :mail_action)
  def perform
    auction = Auction.find(auction_id)
    auction.stores.each do |store|
      store_owner = StoreOwner.find(store.store_owner_id)

      if mail_action == StoreOwnerMailer::STARTED
        StoreOwnerMailer.auction_started(store_owner, auction).deliver
      elsif mail_action == StoreOwnerMailer::UPDATED
        StoreOwnerMailer.auction_updated(store_owner, auction).deliver
      end
    end
  end
end