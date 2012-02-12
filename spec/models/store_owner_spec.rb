describe StoreOwner do
	it 'should have many stores' do
		should have_many(:stores)
	end
end
