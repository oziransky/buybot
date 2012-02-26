require 'spec_helper'
describe AuctionHistory do

  it 'should belong to a user' do
    should belong_to(:user)
  end

end
