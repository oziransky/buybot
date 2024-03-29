class CheckoutsController < ApplicationController

  before_filter :only => [:new, :create, :show]

  def new
    auction_id = params[:auction_id]
    @auction = current_user.auctions.find(auction_id)
    @checkout = Checkout.new(:final_price => @auction.current_price)
    @checkout.auction_id = @auction.id
    @product = Product.find(@auction.product_id)

    respond_to do |format|
      format.html
      format.js { render :partial => 'new'}
    end
  end

  def create
    @checkout = Checkout.create(params[:checkout])
    @auction = current_user.auctions.find(@checkout.auction_id)
    @auction.checkout = @checkout
    @auction.save!

    # build the product URL and redirect
    @checkout.product_url = "http://www.ofiri.co.il/?storeid=6632&view=products&id=534890"
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
    checkout.status = Checkout::COMPLETED
    checkout.save!

    auction = Auction.find(checkout.auction_id)
    auction.status = Auction::SOLD
    auction.save!

    flash[:notice] = t(:product_sale_redirect)

    # run the auction delete
    Delayed::Job.enqueue(PostOnFacebookJob.new(current_user.id, auction.product_id, auction.checkout.final_price, auction.lowest_bidder))
    Delayed::Job.enqueue(AuctionDeleteJob.new(current_user.id, auction.id))

    # redirect to the actual store
    redirect_to checkout.product_url
  end

end
