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
end
