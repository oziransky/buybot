require 'spec_helper'

describe UserMailer do
  before(:each) do
    ActionMailer::Base.deliveries.clear
  end

  describe "auction user mailer" do
    it "should send auction status update for price change" do
      product = FactoryGirl.create(:product)
      auction = FactoryGirl.create(:auction, :product_id => product.id)
      auction.current_price = 1212
      user = FactoryGirl.create(:user)
      user.auctions << auction

      # send the email, then test that it got queued
      email = UserMailer.auction_updated(user, auction).deliver
      ActionMailer::Base.deliveries.should_not be_empty

      # test the content of the email
      email.to.should include(user.email)
      email.subject.should include("#{auction.current_price}")
      email.body.should include("#{user.first_name}")
    end
  end

end
