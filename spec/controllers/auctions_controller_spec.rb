require 'spec_helper'

describe AuctionsController do

  login_user

  it "should have a valid user signed in" do
    subject.current_user.should_not be_nil
  end

  describe "auction creation" do
    it "should create new auction with given product and minimal stores" do
        price1 = FactoryGirl.create(:price)
        product = Product.find(price1.product_id)
        price2 = FactoryGirl.create(:price, :product => product)

        post :create, :product_id => product.id,
                      :store_ids => [ product.stores[0].id, product.stores[1].id ]

        assigns[:auction].product_id.should eql(product.id)
        assigns[:auction].status.should eql(Auction::ACTIVE)

        response.should redirect_to(auctions_path)
    end

    it "should create new auction with given product and large number of stores"

    it "should calculate user rates for sold auction with returning store" do
      # run the background job without delay
      Delayed::Worker.delay_jobs = false

      price1 = FactoryGirl.create(:price)
      product = Product.find(price1.product_id)
      price2 = FactoryGirl.create(:price, :product => product)

      history = FactoryGirl.create(:auction_history)
      subject.current_user.auction_histories << history

      history.add_bid(product.stores[0].id, 100)
      history.add_bid(product.stores[1].id, 110)
      history.save!

      # create auction with 2 stores
      post :create, :product_id => product.id,
                    :store_ids => [ product.stores[0].id, product.stores[1].id ]

      assigns[:auction].product_id.should eql(product.id)
      assigns[:auction].status.should eql(Auction::ACTIVE)

      # should give better rate for first store due to lower bid
      auction = Auction.find_by_product_id(product.id)
      auction.should_not be_nil
      auction.auction_statuses[0].user_rate.should eql(100)
      auction.auction_statuses[1].user_rate.should eql(10)

      response.should redirect_to(auctions_path)
    end
  end

  describe "update" do
    it "should update existing auction with new status" do
      auction = FactoryGirl.create(:auction, :user_id => subject.current_user.id)

      post :update, :id => auction.id, :status => Auction::PAUSED

      assigns[:auction].status.should eql(Auction::PAUSED)

      response.should redirect_to(auction_path)
    end

    it "should flash message if the action status is changed to 'SOLD'" do
      auction = FactoryGirl.create(:auction, :user_id => subject.current_user.id)

      post :update, :id => auction.id, :status => Auction::SOLD

      assigns[:auction].status.should eql(Auction::SOLD)

      flash[:success].should_not be_nil
    end
  end

  it "should delete existing auction" do
    # run the background job without delay
    Delayed::Worker.delay_jobs = false

    auction = FactoryGirl.create(:auction, :user_id => subject.current_user.id)

    post :destroy, :id => auction.id

    assigns[:auction].status.should eql(Auction::CANCELED)

    # make sure that we create a new auction history record
    AuctionHistory.find_by_product_id(auction.product_id).should_not be_nil

    # make sure that the auction is deleted
    Auction.exists?(auction.id).should be_false

    response.should redirect_to(root_path)
  end

  it "should show all open auction for current user" do
    FactoryGirl.create_list(:auction, 3, :user_id => subject.current_user.id)

    get :index

    assigns[:auctions].size.should eql(3)

    response.should be_success
  end

  it "should show a specific auction for current user" do
    auction = FactoryGirl.create(:auction, :user_id => subject.current_user.id)

    get :show, :id => auction.id

    assigns[:auctions].size.should eql(1)

    response.should be_success
  end

end
