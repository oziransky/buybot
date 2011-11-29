class StoreAuctionsController < ApplicationController
  before_filter :only => [:update, :show, :index]


  def update
    @auction = current_auction
    bid = params[:new_bid]
    @auction.current_price = bid

    # save the new record
    if @auction.save
      flash[:success] = "תהליך עודכן בהצלחה"
    else
      flash[:error] = "לא ניתן תעדכן תהליך"
    end

    redirect_to store_auction_path
  end

  def index
    store_id = session[:current_store_id]
    store = Store.find_by_id(store_id)
    # find all active auctions for that store
    @auctions = store.auctions.where("status = ?", Auction::ACTIVE)
  end

  def show
    @auctions = current_auctions
    @auction = current_auction
  end

private

  def current_auctions
    store = Store.find_by_id(session[:current_store_id])
    auctions = store.auctions
    auctions
  end

  def current_auction
    store = Store.find_by_id(session[:current_store_id])
    auctions = store.auctions
    auction = store.auctions.find(params[:id])
    auction
  end
end
