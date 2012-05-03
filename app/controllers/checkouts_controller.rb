class CheckoutsController < ApplicationController

  before_filter :only => [:new, :create, :show]

  def new
    auction_id = params[:auction_id]
    @auction = current_user.auctions.find(auction_id)
    @checkout = Checkout.new(:final_price => @auction.current_price)
    @checkout.auction_id = @auction.id
  end

  def create
    @checkout = Checkout.create(params[:checkout])
    @auction = current_user.auctions.find(@checkout.auction_id)
    @auction.checkout = @checkout

    # build the product URL and redirect
    @checkout.product_url = "http://www.somestore.com/checkouts/?product_id=9928"
    @checkout.status = Checkout::COMPLETED

    if @checkout.save
      logger.debug "Created checkouts. Auction id: #{@auction.id}."
      redirect_to checkout_path(:id => @checkout.id)
    else
      flash[:error] = t(:unable_to_checkout)
      logger.error "Unable to create checkouts."
    end
  end

  def show
    checkout = Checkout.find(params[:id])
    auction = Auction.find(checkout.auction_id)

    flash[:notice] = t(:product_sale_redirect)

    # run the auction delete
    Delayed::Job.enqueue(AuctionDeleteJob.new(current_user.id, auction.id))

    # redirect to the actual store
    redirect_to checkout.product_url
  end

end
