module ControllerMacros
  def login_user
    before(:each) do
      @request.env["devise.mapping"] = Devise.mappings[:user]
      sign_in FactoryGirl.create(:user)
    end
  end

  def login_store_owner
    before(:each) do
      @request.env["devise.mapping"] = Devise.mappings[:store_owner]
      sign_in FactoryGirl.create(:store_owner)
    end
  end
end