class Category < ActiveRecord::Base
  acts_as_tree :order=>"name"
  has_and_belongs_to_many :products
end
