require 'faker'

FactoryGirl.define do

  # factory for the auction history
  factory :auction_history do |f|
    product_id 1
    closed_reason Auction::SOLD
  end
end
