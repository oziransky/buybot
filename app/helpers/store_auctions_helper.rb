module StoreAuctionsHelper
  def other_bids
    list = []

    store_id = session[:current_store_id]
    @auction.auction_statuses.collect { |a|
      if not a.store_id == store_id
        list.insert(0, a.price)
      end
    }
    list.sort!
  end
end
