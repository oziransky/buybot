describe User do
	it 'should have many auctions' do
		should have_many(:auctions)
	end
end
