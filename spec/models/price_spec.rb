
require 'spec_helper'
describe Price do

	it 'should belong to "product"'do 
		should belong_to(:product)
	end
	it 'should belong "store"'do 
		should belong_to(:store) 
	end
	it 'validate numericality of "price"' do 
		should validate_numericality_of(:price)
	end	
	
	it 'should not allow prices less than "0"' do
		price = Price.new(:price=>-1.0)
		price.should_not be_valid
	end
	
	describe "<=>"do
		it '3 should be smaller than 5' do
			a = Price.new(:price=>3.0)
			b = Price.new(:price=>5.0)
			(a<b).should be_true
		end
		
		it '3 should be smaller or equal to 3' do
			a = Price.new(:price=>3.0)
			b = Price.new(:price=>3.0)
			(a<=b).should be_true
		end
		
		it '5 should be greater than 3' do
			a = Price.new(:price=>5.0)
			b = Price.new(:price=>3.0)
			(a>b).should be_true
		end
	end
end
