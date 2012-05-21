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


    sign_in FactoryGirl.create(:user, :access_token=>'AAAEHLlQdMyMBAGPsI7R5J2DS6zs4QL8GHxJpLYQka0ZC6GVtHLAnTGYM2MaZBxyqZBDQJAwZB9YNSW5KPvD3DZCX7Ea6ijN4SeC2NjkzZBbAZDZD')
    store = FactoryGirl.create(:store)
    product = FactoryGirl.create(:product)
    auction = FactoryGirl.create(:auction, :user_id => subject.current_user.id, :product_id=>product.id)
    auction_status = FactoryGirl.create(:auction_status,:store_id => store.id,:auction=>auction,:price=>100)
    auction.auction_statuses << auction_status
    checkout = FactoryGirl.create(:checkout, :auction_id => auction.id, :final_price => auction.current_price )

    get :show, :id => checkout.id

    Auction.find_by_id(auction.id).should be_nil
    Checkout.find_by_id(checkout.id).should be_nil

    response.should redirect_to(checkout.product_url)
  end

end
