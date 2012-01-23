require 'faker'

FactoryGirl.define do

  # factory for a simple product
  factory :product do
    name { Faker::Name.name }
    manufacturer "Someone"
  end
end
