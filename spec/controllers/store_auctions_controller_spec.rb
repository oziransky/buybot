require 'spec_helper'
require 'ruby-debug'

describe StoreAuctionsController do

  login_store_owner

  before(:each) do
    # create basic configuration
    product = FactoryGirl.create(:product)
    @auction = FactoryGirl.create(:auction,:product_id=>product.id)
    @store = FactoryGirl.create(:store)
    subject.current_store_owner.stores << @store
    @store.auctions << @auction
    @store.save

    # add at least one user to the auction
    user = FactoryGirl.create(:user)
    @auction.user_id = user.id
    @auction.save

    ActionMailer::Base.deliveries.clear

    # run the background job without delay
    Delayed::Worker.delay_jobs = false
  end

  describe 'update' do

    it "should assign 'auction' to current_auction"  do

      new_bid = 100.0
      session[:current_store_id] = @store.id
      post 'update', :id=>@auction.id, :new_bid => new_bid.to_s

      assigns[:auction] = @auction

    end

    it "should update the price"  do

      new_bid = 100.0
      session[:current_store_id] = @store.id
      post 'update', :id=>@auction.id, :new_bid => new_bid.to_s

      auction_status = @auction.auction_statuses.where(:store_id=>@store.id).first
      auction_status.price.should eql(new_bid)

    end

    it "should display flash 'success' on successful save"  do

      new_bid = 100.0
      session[:current_store_id] = @store.id
      post 'update', :id=>@auction.id, :new_bid=>new_bid.to_s

      flash[:success].should_not be_nil

    end

    it "should display redirect to store_auction"  do

      new_bid = 100.0
      session[:current_store_id] = @store.id
      post 'update',:id=>@auction.id,:new_bid=>new_bid.to_s

      response.should redirect_to store_auction_path

    end

    it "should send update email to user"  do

      new_bid = 100.0
      session[:current_store_id] = @store.id
      post 'update',:id=>@auction.id,:new_bid=>new_bid.to_s

      ActionMailer::Base.deliveries.should_not be_empty

    end
  end

  describe 'index' do

    it "should redirect to store_path if store is not selected" do

      #set non existent store
      session[:current_store_id]= -1
      post 'index'

      flash[:error].should_not be_nil
      response.should redirect_to stores_path

    end

    it "should assign Active or Paused auctions" do

      #create more auctions
      auctions = FactoryGirl.create_list(:auction,3)
      #set the first one status to canceled. it should not be displayed
      auctions.first.status = Auction::CANCELED
      assert auctions.first.save

      auctions.each {|a| @store.auctions << a}
      assert @store.save

      session[:current_store_id]= @store.id
      post 'index'

      assigns[:auctions].size.should eql(3)
      assigns[:auctions].should include(@auction,auctions[1],auctions[2])
      assigns[:auctions].should_not include(auctions[0])

    end

  end

  describe 'show' do

    it "should assign auctions to all store auctions" do

      #create more auctions
      auctions = FactoryGirl.create_list(:auction,3)
      auctions.each {|a| @store.auctions << a}
      assert @store.save

      session[:current_store_id]= @store.id
      post :show,:id=>@auction.id

      assigns[:auctions].size.should eql(4)
      assigns[:auctions].should include(@auction,auctions[0],auctions[1],auctions[2])
      assigns[:auction].should == @auction

    end
  end

  describe "message" do

    it "should send a message to the user" do

      msg_text = "This is a text message"

      post :message, :message_text => msg_text
      assigns[:message].should eql(msg_text)

      flash[:success].should_not be_nil
    end
  end

end

