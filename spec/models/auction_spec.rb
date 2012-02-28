require 'spec_helper'
describe Auction do
  it 'should have many auctioin_statuses' do
    should have_many(:auction_statuses)
  end
  it 'should have many stores' do
    should have_many(:stores)
  end

  describe 'active?' do
    it 'should answer "true" on active auction' do
      active_auction = FactoryGirl.create(:auction, :status=>Auction::ACTIVE)
      active_auction.active?.should be_true
    end

    it 'should answer "false" on inactive auction' do

      canceled_auction = FactoryGirl.create(:auction, :status=>Auction::CANCELED)
      sold_auction = FactoryGirl.create(:auction, :status=>Auction::SOLD)
      paused_auction = FactoryGirl.create(:auction, :status=>Auction::PAUSED)
      timeout_auction = FactoryGirl.create(:auction, :status=>Auction::TIMEOUT)
      
      canceled_auction.active?.should be_false
      sold_auction.active?.should be_false
      paused_auction.active?.should be_false
      timeout_auction.active?.should be_false
    end
    
  end
  describe 'auction_status' do
    it 'should print auction status as string' do

      active_auction = FactoryGirl.create(:auction, :status=>Auction::ACTIVE)
      canceled_auction = FactoryGirl.create(:auction, :status=>Auction::CANCELED)
      sold_auction = FactoryGirl.create(:auction, :status=>Auction::SOLD)
      paused_auction = FactoryGirl.create(:auction, :status=>Auction::PAUSED)
      timeout_auction = FactoryGirl.create(:auction, :status=>Auction::TIMEOUT)
      active_auction.status_to_s.should == "Active"  
      canceled_auction.status_to_s.should == "Canceled"
      sold_auction.status_to_s.should == "Sold"
      paused_auction.status_to_s.should == "Paused"
      timeout_auction.status_to_s.should == "Timeout"

    end
  end
end

