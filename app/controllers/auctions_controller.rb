# encoding: utf-8

class AuctionsController < ApplicationController

  before_filter :require_login

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

    # virgin auction
    @auction.bids_received = false

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

    # send emails to all store owners indicating that auction was started
    Delayed::Job.enqueue(AuctionStoreMailJob.new(@auction.id,
                                                 StoreOwnerMailer::STARTED))

    # show all open auctions for this user
    redirect_to @auction
  end

  def update
    @auction = current_user.auctions.find(params[:id])
    @auction.status = params[:status].to_i

    # send emails to all store owners indicating that auction was updated
    Delayed::Job.enqueue(AuctionStoreMailJob.new(@auction.id,
                                                 StoreOwnerMailer::UPDATED))
    # save the new record
    if @auction.save
      if @auction.status == Auction::CHECKOUT
        # start the checkouts process
        logger.debug "Start checkouts. Auction id: #{@auction.id}."

        respond_to do |format|
          format.html { redirect_to new_checkout_path(:auction_id => @auction.id) }
          format.js { render :js => "window.location = '#{new_checkout_path(:auction_id => @auction.id)}'" }
        end
      else
        flash[:success] = t(:process_updated)
        logger.debug "Updating auction. Auction id: #{@auction.id}. Auction status: #{@auction.status}"

        respond_to do |format|
          format.html { redirect_to auction_path }
          format.js
        end
      end
    else
      flash[:error] = t(:could_not_update_process)
      logger.error "Unable to update auction. Auction id: #{@auction.id}. Auction status: #{@auction.status}"
    end
  end

  def destroy
    # just mark the auction as inactive - will be cleared after
    @auction = current_user.auctions.find(params[:id])
    @auction.status = Auction::CANCELED

    # send emails to all store owners indicating that auction was updated
    Delayed::Job.enqueue(AuctionStoreMailJob.new(@auction.id,
                                                 StoreOwnerMailer::UPDATED))
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
    respond_to do |format|
      format.html { redirect_to root_path }
      format.js { render :js => "window.location = '/'" }
    end
  end

  def index
    @auctions = current_user.auctions

    if @auctions.size == 0
      flash[:warning] = t(:no_open_auctions)
      redirect_to request.referer
    elsif @auctions.size == 1
      redirect_to @auctions[0]
    end
  end

  def show
    @auction = current_user.auctions.find(params[:id])

    # handle the case when the auction timeout with bids
    # in this case we need to proceed automatically to checkout
    # because the UI will periodically check for updates, here is the place
    # for that specific status
    if @auction.status == Auction::CHECKOUT
      flash[:success] = t(:automatic_checkout)
      # start the checkouts process
      logger.debug "Start automatic checkouts. Auction id: #{@auction.id}."
      redirect_to new_checkout_path(:auction_id => @auction.id)
    else
      # auction is still active
      @auctions = current_user.auctions
      @product = Product.find(@auction.product_id)
      @stores = @auction.stores

      respond_to do |format|
        format.html
        format.js
      end
    end
  end

  def message

  end

  private

  def require_login
    unless user_signed_in?
      flash[:error] = t(:must_be_logged)
      # save the current url to return to
      session["user_return_to"] = request.fullpath
      redirect_to new_user_session_path
    end
  end
end
