require 'spec_helper'

describe AuctionsController do
  fixtures :all

  login_user

  it "should have a valid user signed in" do
    subject.current_user.should_not be_nil
  end

  it "should create new auction with given product" do
    product = Product.first

    post :create, :product_id => product.id,
                  :store_ids => [ product.stores.first.id, product.stores.last.id ]

    assigns[:auction].product_id.should == product.id
    assigns[:auction].status.should == Auction::ACTIVE

    response.should redirect_to(auctions_path)
  end

  it "should update existing auction with new status" do
    auction = FactoryGirl.create(:auction, :user_id => subject.current_user.id)

    post :update, :id => auction.id, :status => Auction::PAUSED

    assigns[:auction].status.should == Auction::PAUSED

    response.should redirect_to(auction_path)
  end

  it "should delete existing auction" do
    auction = FactoryGirl.create(:auction, :user_id => subject.current_user.id)

    post :destroy, :id => auction.id

    assigns[:auction].status.should == Auction::CANCELED

    response.should redirect_to(root_path)
  end

  it "should show all open auction for current user" do
    FactoryGirl.create_list(:auction, 3, :user_id => subject.current_user.id)

    get :index

    assigns[:auctions].size.should == 3

    response.should be_success
  end

  it "should show a specific auction for current user" do
    auction = FactoryGirl.create(:auction, :user_id => subject.current_user.id)

    get :show, :id => auction.id

    assigns[:auctions].size.should == 1

    response.should be_success
  end

end