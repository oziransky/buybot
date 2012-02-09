class Category < ActiveRecord::Base
  attr_accessible :name

  acts_as_tree :order=>"name"
  	
  has_and_belongs_to_many :products
  validates :name, :presence => true
  
  
  # helper method to extract all top level categories
  def self.top_categories
    select("*").where("parent_id is null")
  end
  
  # helper method to extract all sub categories
  def self.sub_categories
    select("*").where("parent_id is not null")
  end
  
  def top_level?
    parent_id.nil?
  end
  
end
