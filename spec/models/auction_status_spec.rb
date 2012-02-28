describe AuctionStatus do
	
	it {should validate_presence_of(:store_id)}	
	it {should validate_presence_of(:auction_id)}
	
	it {should belong_to(:store)}	
	it {should belong_to(:auction)}	

end
