require 'test_helper'

class AuctionsControllerTest < ActionController::TestCase
  test "should get closed" do
    get :closed
    assert_response :success
  end

  test "should get open" do
    get :open
    assert_response :success
  end

end
