require 'spec_helper'

describe AuctionsController do
  login_user

  it "should have a valid user signed in" do
    subject.current_user.should_not be_nil
  end

  it "should create new auction with given product" do
    price1 = FactoryGirl.create(:price)
    product = Product.find(price1.product_id)
    price2 = FactoryGirl.create(:price, :product => product)

    post :create, :product_id => product.id,
      :store_ids => [ product.stores.first.id, product.stores.last.id ]

    assigns[:auction].product_id.should eql(product.id)
    assigns[:auction].status.should eql(Auction::ACTIVE)

    response.should redirect_to(auctions_path)
  end

  describe 'update' do
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
