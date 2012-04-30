require "spec_helper"

describe StoreOwnerMailer do
  before(:each) do
    ActionMailer::Base.deliveries.clear

    product = FactoryGirl.create(:product)
    @auction = FactoryGirl.create(:auction, :product_id => product.id)
    @store_owner1 = FactoryGirl.create(:store_owner)
    @store_owner2 = FactoryGirl.create(:store_owner)
    store1 = FactoryGirl.create(:store)
    store2 = FactoryGirl.create(:store)
    @store_owner1.stores << store1
    @store_owner2.stores << store2
    @auction.stores[0] = store1
    @auction.stores[1] = store2
  end

  describe "auction store mailer" do
    it "should send auction start indication to the store owners" do

      # send the email, then test that it got queued
      email1 = StoreOwnerMailer.auction_started(@store_owner1, @auction).deliver
      email2 = StoreOwnerMailer.auction_started(@store_owner2, @auction).deliver
      ActionMailer::Base.deliveries.size.should eql(2)

      # test the content of the email
      email1.to.should include(@store_owner1.email)
      email2.to.should include(@store_owner2.email)
      email1.body.should include("#{@store_owner1.first_name}")
      email2.body.should include("#{@store_owner2.first_name}")

    end

    it "should send auction updated indication to the store owners" do

      @auction.status = Auction::PAUSED

      # send the email, then test that it got queued
      email1 = StoreOwnerMailer.auction_updated(@store_owner1, @auction).deliver
      email2 = StoreOwnerMailer.auction_updated(@store_owner2, @auction).deliver
      ActionMailer::Base.deliveries.size.should eql(2)

      # test the content of the email
      email1.to.should include(@store_owner1.email)
      email1.subject.should include(@auction.status_to_s)
      email2.to.should include(@store_owner2.email)
      email2.subject.should include(@auction.status_to_s)
      email1.body.should include("#{@store_owner1.first_name}")
      email2.body.should include("#{@store_owner2.first_name}")
    end

  end
end
