require 'spec_helper'
require 'ruby-debug'
describe StoreAuctionsController do


  login_store_owner

  describe 'update' do
    it "should assign 'auction' to current_auction" do 
      auction = FactoryGirl.create(:auction)
      puts subject.current_store_owner.id
      store = FactoryGirl.create(:store)
      subject.current_store_owner.stores << store
      store.auctions << auction
      store.save
      puts subject.current_store_owner.store_ids
      session[:current_store_id]=store.id
      post 'update',:id=>auction.id,:new_bid=>"100"
      assigns[:auction] = auction
    end
  end
  describe 'index' do
  end
  describe 'show' do
  end

end

