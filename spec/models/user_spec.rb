require 'spec_helper'

describe User do
  it 'should have many auctions' do
    should have_many(:auctions)
  end

  it 'should have many auction histories' do
    should have_many(:auction_histories)
  end
end
