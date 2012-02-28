require 'spec_helper'
describe Category do
	
	before(:each) do
		#create electronics root category
		@electronics = FactoryGirl.create(:root,:name=>"Electronics")
		televsions = FactoryGirl.create_list(:televisions,2,:parent=>@electronics) 
	end
	
	it 'should have a valid name' do 
		should validate_presence_of(:name)
	end
	
	it 'model should be able to find top level categories' do
		
		root_categories = Category.top_categories
		
		root_categories.each do |c|
			c.parent.should be_nil
		end
		
	end
	
	describe 'top_level?' do
		let(:electronics) {FactoryGirl.create(:root,:name=>"Electronics")}
		let(:television) {FactoryGirl.create(:televisions,:parent=>electronics)}
		it 'should answer true if parent is nil' do
			electronics.should_not be_nil
			electronics.top_level?.should be(true)			
		end
		it 'should answer false if parent is not nil' do
			television.should_not be_nil
			television.top_level?.should be(false)			
		end
	end		
end
