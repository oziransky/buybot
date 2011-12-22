class StoreAuctionsController < ApplicationController
  before_filter :only => [:update, :show, :index]

  def update
    # TODO: check that the bid is in the set range
    @auction = current_auction
    bid = params[:new_bid]

    # mark the current price with the new one
    @auction.current_price = bid

    # store this store bid in the association table
    store_id = session[:current_store_id]
    @auction.auction_statuses.where("store_id = ?", store_id).first.update_attributes(:price => bid)

    # save the new record
    if @auction.save
      flash[:success] = "New process was created successfully"
    else
      flash[:error] = "Unable to create a new process"
    end

    redirect_to store_auction_path
  end

  def index
    store_id = session[:current_store_id]
    store = Store.find_by_id(store_id)

    if store.nil?
      flash[:error] = "Please choose a store first"
      redirect_to stores_path
    else
      # find all active auctions for that store
      @auctions = store.auctions.where("status = ? OR status = ?", Auction::ACTIVE, Auction::PAUSED)
    end
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
    auction = store.auctions.find(params[:id])
    auction
  end
end
