class Category < ActiveRecord::Base
  attr_accessible :name

  acts_as_tree :order=>"name"

  has_and_belongs_to_many :products
end
