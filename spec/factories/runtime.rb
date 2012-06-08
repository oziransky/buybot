require 'faker'

FactoryGirl.define do

  # factory for the auction
  factory :auction do
    close_at DateTime.now
    product_id 1
    current_price 100
    status Auction::ACTIVE
  end

  factory :auction_status do

  end

  # factory for checkout process
  factory :checkout do
    auction_id 1
    final_price 100
    product_url { Faker::Internet.domain_name }
  end

end
