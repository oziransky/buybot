require 'spec_helper'

describe AuctionsController do
  # build basic inventory of the store
  fixtures :all

  login_user

  it "should have a current_user" do
    subject.current_user.should_not be_nil
  end

end