require 'faker'

FactoryGirl.define do

  # factory for the auction
  factory :auction do
    product_id 1
    current_price 100
    status Auction::ACTIVE
  end

  factory :store do
    name Faker::Name.name
    address Faker::Address.street_address
    url Faker::Internet.domain_name
    description Faker::Lorem.sentence(2)
  end
end
