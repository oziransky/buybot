require 'spec_helper'
describe Category do
	
	it 'should have a valid name' do 
		should validate_presence_of(:name)
	end
	
	it 'model should be able to find top level categories' do
		root = FactoryGirl.create(:root, :name=>"Electronics")
		televisioins = FactoryGirl.create_list(:televisions, 3, :parent=>root)
		categories = Category.all
		categories.each do |c| 
			puts  "#{c.id} " + c.name
			#puts c.parent
		end
		
	end	
end
