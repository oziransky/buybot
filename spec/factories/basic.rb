require 'faker'

FactoryGirl.define do

  # factory for the site user
  factory :user do
    sequence(:email) {|n| "person#{n}@gmail.com"}
    password "123456"
    password_confirmation "123456"
  end
 
end
