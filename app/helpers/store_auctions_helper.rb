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

  def user_rate(auction)
    store_id = session[:current_store_id]
    rate = auction.auction_statuses.where("store_id = ?", store_id).first.user_rate
    if not rate.nil?
      rate
    else
      "N/A"
end
  end
end
