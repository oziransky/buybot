# Background job that creates auction user rating
class AuctionUserRateJob < Struct.new(:user_id, :auction_id)
  def perform
    # get the current user
    user = User.find(user_id)

    # get the stores participating in this auction
    auction = Auction.find(auction_id)

    # basic calculation - reoccurring stores
    # 1. check if the user had already chosen the store in previous auctions
    # 2. give better rate for stores with lower bids
    # 3. give better rate based on auction status
    rates = Hash.new

    auction.stores.each { |store|
      rates[store.id] = 0
      user.auction_histories.each { |history|
        if history.has_bid?(store.id)
          # was this the lowest bid during the auction
          if history.get_lowest_bid_store == store.id
            # give some extra credit for getting the best bid (20%)
            rates[store.id] += 20
            # did the auction close with checkout
            if history.closed_reason == Auction::SOLD
              # give maximum rate (80%)
              rates[store.id] += 80
            end
          else
            # just the basic credit (10%)
            rates[store.id] += 10
          end
        end
      }
    }

    # update the status of the auction for each store
    rates.each { |item|
      id, rate = item
      status = auction.auction_statuses.where("store_id = ?", id).first
      status.update_attributes(:user_rate => rate)
      auction.save!
    }
  end
end