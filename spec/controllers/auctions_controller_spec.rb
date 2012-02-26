require 'spec_helper'

describe AuctionsController do
  fixtures :all

  login_user

  it "should have a valid user signed in" do
    subject.current_user.should_not be_nil
  end

  it "should create new auction with given product" do
    # TODO: change to factories and not fixtures for the product here
    product = Product.first

    post :create, :product_id => product.id,
                  :store_ids => [ product.stores.first.id, product.stores.last.id ]

    assigns[:auction].product_id.should eql(product.id)
    assigns[:auction].status.should eql(Auction::ACTIVE)

    response.should redirect_to(auctions_path)
  end

  it "should update existing auction with new status" do
    auction = FactoryGirl.create(:auction, :user_id => subject.current_user.id)

    post :update, :id => auction.id, :status => Auction::PAUSED

    assigns[:auction].status.should eql(Auction::PAUSED)

    response.should redirect_to(auction_path)
  end

  it "should delete existing auction" do
    auction = FactoryGirl.create(:auction, :user_id => subject.current_user.id)

    jobs = Delayed::Job.count

    post :destroy, :id => auction.id

    assigns[:auction].status.should eql(Auction::CANCELED)

    # make sure that we have a new background job added
    Delayed::Job.count.should eql(jobs+1)

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