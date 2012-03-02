# Background job that handles the auction delete process
# 1. Save the product that the user was interested in
# 2. Save the stores that the user was interested in
# 3. Save the delete reason (timeout or cancellation)
class AuctionDeleteJob < Struct.new(:user_id, :auction_id)
  def perform
    user = User.find(user_id)
    auction = Auction.find(auction_id)

    history = user.auction_histories.new(:product_id => auction.product_id)

    # use the same status format
    history.closed_reason = auction.status

    # build a hash with all stores and bids
    history.bids = Hash.new
    auction.stores.each { |store|
      history.add_bid(store.id, auction.auction_statuses.where("store_id = ?", store.id).first.price)
    }
    history.save!

    # delete the auction record
    auction.destroy
  end
end