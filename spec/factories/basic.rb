require 'faker'

FactoryGirl.define do

  sequence :email do |n|
    "person#{n}@gmail.com"
  end

  # factory for the site user
  factory :user do
    email
    password "123456"
    password_confirmation "123456"
  end

  # factory for the store owner
  factory :store_owner do
    email
    password "123456"
    password_confirmation "123456"
  end
end
