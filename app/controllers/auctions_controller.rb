# encoding: utf-8

class AuctionsController < ApplicationController

  def create
    product_id = params[:product_id]

    @auction = current_user.auctions.new(:product_id => product_id)

    # mark all stores that are participating in the auction
    params[:store_ids].each_with_index do |id, item|
      store = Store.find(id)
      @auction.stores[item] = store
    end

    # save the new record
    @auction.save

    prices = []

    # build a list of all prices and save them in association table
    @auction.stores.each_with_index do |store, item|
      plist = Price.where("product_id = ? AND store_id = ?", product_id, store.id)
      prices.insert(0, plist.first.price)
      @auction.auction_statuses[item].update_attributes(:price => plist.first.price)
    end

    # save lowest price
    @auction.current_price = prices.sort!().first

    # set some defaults
    @auction.minimal_step = 50
    @auction.maximum_step = 100
    @auction.max_num_bids = 10

    # start the auction
    @auction.status = Auction::ACTIVE

    # mark the close date
    @auction.close_at = (Time.now + Auction::DEFAULT_TIME).to_s(:db)

    # save the new record
    if @auction.save
      flash[:success] = t(:process_created)
      logger.debug "Created auction. Auction id: #{@auction.id}."
    else
      flash[:error] = t(:could_not_create_process)
      logger.error "Unable to create auction."
    end

    # run the rate calculation background job
    Delayed::Job.enqueue(AuctionUserRateJob.new(current_user.id, @auction.id))

    # show all open auctions for this user
    redirect_to auctions_path
  end

  def update
    @auction = current_user.auctions.find(params[:id])
    @auction.status = params[:status].to_i

    # save the new record
    if @auction.save
      flash[:success] = t(:process_updated)
      logger.debug "Updating auction. Auction id: #{@auction.id}. Auction status: #{@auction.status}"
      if @auction.status == Auction::SOLD
        # should redirect to selling the product
        flash[:notice] = t(:product_sold)
        Delayed::Job.enqueue(AuctionDeleteJob.new(current_user.id, @auction.id))
      end
    else
      flash[:error] = t(:could_not_update_process)
      logger.error "Unable to update auction. Auction id: #{@auction.id}. Auction status: #{@auction.status}"
    end

    redirect_to auction_path
  end

  def destroy
    # just mark the auction as inactive - will be cleared after
    @auction = current_user.auctions.find(params[:id])
    @auction.status = Auction::CANCELED

    # save the new record
    if @auction.save
      # create a background task that will handle the analysis and delete the auction
      Delayed::Job.enqueue(AuctionDeleteJob.new(current_user.id, @auction.id))
      flash[:success] = t(:process_deleted)
      logger.debug "Deleting auction. Auction id: #{@auction.id}"
    else
      flash[:error] = t(:could_not_delete_process)
      logger.error "Unable to delete auction. Auction id: #{@auction.id}"
    end

    # let the system process, go home
    redirect_to root_path
  end

  def index
    @auctions = current_user.auctions
  end

  def show
    @auctions = current_user.auctions
    @auction = current_user.auctions.find(params[:id])

    @store_names = []
    @auction.stores.size.times do |index|
      @store_names[index] = @auction.stores[index].name
    end
  end

end
