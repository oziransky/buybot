require 'spec_helper'
require 'faker'

describe StoresController do

  login_store_owner

  it "should have a valid user signed in" do
    subject.current_store_owner.should_not be_nil
  end

  it "should create a new store for owner" do
    stores = Store.count

    name = Faker::Name.name
    address = Faker::Address.street_address
    url = Faker::Internet.domain_name
    description = Faker::Lorem.sentence(2)

    post :create, :store => { :name => name,
                              :address => address,
                              :url => url,
                              :description => description }

    assigns[:store].should_not be_nil
    assigns[:store].name.should eql(name)
    assigns[:store].address.should eql(address)
    assigns[:store].url.should eql(url)
    assigns[:store].description.should eql(description)

    Store.count.should eql(stores+1)

    response.should redirect_to(stores_path)
  end

  it "should update existing store for owner" do
    store = FactoryGirl.create(:store, :store_owner_id => subject.current_store_owner.id)

    # update some information just to see that the method works
    name = Faker::Name.name
    post :update, :id => store.id, :store => { :name => name }

    assigns[:store].should_not be_nil
    assigns[:store].name.should eql(name)

    # check that other remained the same
    assigns[:store].address.should eql(store.address)
    assigns[:store].url.should eql(store.url)
    assigns[:store].description.should eql(store.description)
  end

  it "should show all stores for owner" do
    created_stores = FactoryGirl.create_list(:store, 3, :store_owner_id => subject.current_store_owner.id)

    get :index

    assigns[:stores].size.should eql(3)

    response.should be_success
  end

  it "should show specific store for owner" do
    store = FactoryGirl.create(:store, :store_owner_id => subject.current_store_owner.id)

    get :show, :id => store.id

    assigns[:store].name.should eql(store.name)

    response.should be_success
  end

  it "should delete existing store for owner" do
    store = FactoryGirl.create(:store, :store_owner_id => subject.current_store_owner.id)

    stores = Store.count

    post :destroy, :id => store.id

    Store.count.should eql(stores-1)

    response.should redirect_to(stores_path)
  end
end