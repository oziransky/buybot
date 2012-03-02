require 'faker'

FactoryGirl.define do

  sequence :name do |n|
    "Category#{n}"
  end

  factory :category do
    name
  end

  factory :product do |p|
    name { Faker::Name.name }
    description { Faker::Lorem.sentence(2) }
    url { Faker::Internet.domain_name }
    image_folder "public/data/p2"
    manufacturer "IKEA"

    p.categories { |a| [a.association(:category)] }
  end

  factory :store do
    name { Faker::Name.name }
    address { Faker::Address.street_address }
    url { Faker::Internet.domain_name }
    description { Faker::Lorem.sentence(2) }
  end

  factory :price do |p|
    price 100

    p.product { |a| a.association(:product) }
    p.store { |a| a.association(:store) }
  end

end
