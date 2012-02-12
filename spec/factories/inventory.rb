require 'faker'

FactoryGirl.define do

  # factory for a simple product
  factory :product do
    name { Faker::Name.name }
    manufacturer "Someone"
  end
  
  
  factory :price do |p|
	p.product {|a| a.association(:product)}
	p.store {|a| a.association(:store)}
  end
end
