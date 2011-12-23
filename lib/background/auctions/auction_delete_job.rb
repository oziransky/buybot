# Background job that handles the auction delete process
# 1. Save the product that the user was interested in
# 2. Save the stores that the user was interested in
# 3. Save the delete reason (timeout or cancellation)
class AuctionDeleteJob < Struct.new(:auction_id)
  def perform
    auction = Auction.find(auction_id)
    history = AuctionHistory.new(:product_id => auction.product_id)

    # use the same status format
    history.closed_reason = auction.status

    # build a hash with all stores and bids
    history.bids = Hash.new
    auction.stores.each { |store|
      history.bids["store_id_#{store.id}"] = auction.auction_statuses.where("store_id = ?", store.id).first.price
    }
    history.save!

    # delete the auction record
    #logger.info "Deleted auction record id:#{auction.id}"
    auction.destroy
  end
end