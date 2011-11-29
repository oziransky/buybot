class AuctionsController < ApplicationController

  def create
    prices = []
    product_id = params[:product_id]

    @auction = current_user.auctions.new(:product_id => product_id)
    # mark all stores that are participating in the auction
    params[:store_ids].each_with_index do |id, item|
      store = Store.find(id)
      @auction.stores[item] = store
      # build a list of all prices
      list = Price.where("product_id = ? AND store_id = ?", product_id, id)
      list.each do |p|
        prices.insert(0, p.price)
      end
    end

    # save lowest price
    @auction.current_price = prices.sort!().first()

    # set some defaults
    @auction.minimal_step = 50
    @auction.maximum_step = 100
    @auction.max_num_bids = 10

    # start the auction
    @auction.status = Auction::ACTIVE

    # save the new record
    if @auction.save
      flash[:success] = "תהליך נוצר בהצלחה"
    else
      flash[:error] = "לא ניתן להתחיל תהליך"
    end

    # show all open auctions for this user
    redirect_to auctions_path
  end

  def update
    @auction = current_user.auctions.find(params[:id])
  end

  def delete
    # just mark the auction as inactive - will be cleared after
    @auction.status = Auction::INACTIVE

    # show all open auctions for this user
    redirect_to auctions_path
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
