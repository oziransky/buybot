require 'test_helper'

class StoresControllerTest < ActionController::TestCase
  test "should get stores" do
    get :stores
    assert_response :success
  end

end
