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
    @auction.status = params[:status].to_i

    # save the new record
    if @auction.save
      flash[:success] = "תהליך עודכן בהצלחה"
    else
      flash[:error] = "לא ניתן לעדכן תהליך"
    end

    redirect_to auction_path
  end

  def destroy
    # just mark the auction as inactive - will be cleared after
    @auction = current_user.auctions.find(params[:id])
    @auction.status = Auction::INACTIVE

    # save the new record
    if @auction.save
      flash[:success] = "תהליך בוטל בהצלחה"
    else
      flash[:error] = "לא ניתן לבטל תהליך"
    end

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
