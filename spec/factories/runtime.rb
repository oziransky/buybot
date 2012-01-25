FactoryGirl.define do

  # factory for the auction
  factory :auction do
    product_id 1
    current_price 100
    status Auction::ACTIVE
  end
end
