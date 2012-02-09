require 'faker'

FactoryGirl.define do

 factory :root, :class=>Category do
	name "Electronics"
  end
  
  factory :televisions, :class=>Category do
	sequence(:name) {|n| "Television#{n}" }
	association :parent, :factory=> :root, :name=>"Electronics"  
  end

end
