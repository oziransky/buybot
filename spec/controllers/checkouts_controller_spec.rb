require 'spec_helper'

describe CheckoutsController do

  login_user

  before (:each) do
    # run the background job without delay
    Delayed::Worker.delay_jobs = false
  end

  it "should create a new checkout process" do
    auction = FactoryGirl.create(:auction, :user_id => subject.current_user.id)

    get :new, :auction_id => auction.id
    assigns[:checkout].should_not be_nil
    assigns[:checkout].auction_id.should eql(auction.id)

    response.should be_success
  end

  it "should create a checkout process and redirect to show" do
    auction = FactoryGirl.create(:auction, :user_id => subject.current_user.id)
    subject.current_user.auctions << auction

    post :create, :checkout => { :final_price => auction.current_price, :auction_id => auction.id }

    assigns[:checkout].should_not be_nil
    assigns[:checkout].auction_id.should eql(auction.id)
    assigns[:checkout].status.should eql(Checkout::COMPLETED)

    response.should redirect_to(checkout_path(:id => assigns[:checkout].id))
  end

  it "should redirect to checkout url" do
    auction = FactoryGirl.create(:auction, :user_id => subject.current_user.id)
    checkout = FactoryGirl.create(:checkout, :auction_id => auction.id, :final_price => auction.current_price )

    get :show, :id => checkout.id

    Auction.find_by_id(auction.id).should be_nil
    Checkout.find_by_id(checkout.id).should be_nil

    response.should redirect_to(checkout.product_url)
  end

end
