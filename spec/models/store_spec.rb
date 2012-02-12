describe Store do
	
	it 'belongs to store_owner' do
		should belong_to(:store_owner)
	end
	it 'has many prices' do
		should have_many(:prices)
	end
	it 'has many products' do
		should have_many(:products)
	end
	it 'has many auction_statuses' do
		should have_many(:auction_statuses)
	end
	it 'has many auctions' do
		should have_many(:auctions)
	end
	it 'should have a valid name' do
		should validate_presence_of(:name)
	end
	it 'should have a valid url' do
		should validate_presence_of(:url)
	end
	
	describe 'product_price' do
		it 'should find a price of a product' do
			price = FactoryGirl.create(:price,:price=>100.0)
			price.store.product_price(price.product).should == 100.0
		end
	end

end
