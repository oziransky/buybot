require 'spec_helper'

describe Checkout do

  it 'should belong to "auction"'do
    should belong_to(:auction)
  end

end
