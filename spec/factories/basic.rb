require 'faker'

FactoryGirl.define do

  # factory for the site user
  factory :user do
    sequence(:email) {|n| "person#{n}@gmail.com"}
    password "123456"
    password_confirmation "123456"
  end
 

  # factory for the store owner
  factory :store_owner do
    sequence(:email) {|n| "store#{n}@gmail.com"}
    password "123456"
    password_confirmation "123456"
  end
end
