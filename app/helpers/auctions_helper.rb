# encoding: utf-8
module AuctionsHelper
  def get_toggle_status
    if @auction.status == Auction::ACTIVE
      Auction::PAUSED
    else
      Auction::ACTIVE
    end
  end

  def get_toggle_link
    if @auction.status == Auction::ACTIVE
      "Pause Auction"
    else
      "Resume Auction"
    end
  end

  def get_auction_price(store)
    @auction.auction_statuses.where("store_id = ?", store.id).first.price
  end

end
