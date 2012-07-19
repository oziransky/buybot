class StoreAuctionsController < ApplicationController
  before_filter :only => [:update, :show, :index]

  def update
    @auction = current_auction

    # mark the auction as one that already received bids
    @auction.bids_received = true

    bid = params[:new_bid]

    # mark the current price with the new one
    @auction.current_price = bid

    # store this store bid in the association table
    store_id = session[:current_store_id]
    @auction.auction_statuses.where("store_id = ?", store_id).first.update_attributes(:price => bid)

    # save the new record
    if @auction.save
      flash[:success] = "Auction was updated successfully"
    else
      flash[:error] = "Unable to update auction"
    end

    # send email to user indicating that auction was updated
    Delayed::Job.enqueue(AuctionUserMailJob.new(@auction.user_id, @auction.id))

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

      @products = []

      @auctions.each do |auction|
        @products.push(Product.find(auction.product_id))
      end
    end
  end

  def show
    @auctions = current_auctions
    @auction = current_auction
    @user_fb_info = FacebookInfo.find_by_user_id(@auction.user_id)
    @product = Product.find(@auction.product_id)
  end

  def message
    @message = params[:message_text]

    flash[:success] = "Message was successfully sent to user"

    respond_to do |format|
      format.js
    end
  end

private

  def current_auctions
    store = Store.find_by_id(session[:current_store_id])
    auctions = store.auctions
  end

  def current_auction
    store = Store.find_by_id(session[:current_store_id])
    auction = store.auctions.find(params[:id])
  end
end
