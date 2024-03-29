require 'spec_helper'
require 'faker'

describe ProductsController do

  login_store_owner

  before :each do
    @file = fixture_file_upload('/files/feed_file.csv')

    Delayed::Worker.delay_jobs = false
  end

  it "should have a valid user signed in" do
    subject.current_store_owner.should_not be_nil
  end

  it "should create a new product" do

    # create the price (will make sure all the rest is there)
    price = FactoryGirl.create(:price)
    store = Store.find(price.store_id)

    name = Faker::Name.name
    url = Faker::Internet.domain_name
    image_folder = "/public/folder"
    description = Faker::Lorem.sentence(2)
    manufacturer = "Sony"

    # emulate coming from a specific store
    session[:current_store_id] = store.id

    post :create, :product => { :name => name,
                                :url => url,
                                :image_folder => image_folder,
                                :description => description,
                                :manufacturer => manufacturer,
                                :category_ids => [Category.top_categories.first.id],
                                :prices_attributes => { "0" => { :price => 1000, :store_id => store.id} }
                              }

    assigns[:product].name.should eql(name)
    assigns[:product].url.should eql(url)
    assigns[:product].image_folder.should eql(image_folder)
    assigns[:product].description.should eql(description)
    assigns[:product].manufacturer.should eql(manufacturer)

    response.should redirect_to(products_path)

  end

  it "should update existing product" do

    # create the price (will make sure all the rest is there)
    price = FactoryGirl.create(:price)
    store = Store.find(price.store_id)
    product = Product.find(price.product_id)

    name = Faker::Name.name
    url = Faker::Internet.domain_name
    image_folder = "/public/folder"
    description = Faker::Lorem.sentence(2)
    manufacturer = "Sony"

    # emulate coming from a specific store
    session[:current_store_id] = store.id

    # just update the name
    post :update, :id => product.id, :product => { :name => name }

    assigns[:product].name.should eql(name)

    response.should redirect_to(product_path)

  end

  it "should delete a specific product" do

    # create the price (will make sure all the rest is there)
    price = FactoryGirl.create(:price)
    store = Store.find(price.store_id)
    product = Product.find(price.product_id)

    # emulate coming from a specific store
    session[:current_store_id] = store.id

    post :destroy, :id => product.id

    response.should redirect_to(products_path)

  end

  it "should show all available products" do

    store = FactoryGirl.create(:store)
    FactoryGirl.create_list(:price, 3, :store_id=>store.id)
    # emulate coming from a specific store
    session[:current_store_id] = store.id

    get :index

    assigns[:products].size.should eql(3)

    response.should be_success

  end

  it "should show a specific product" do

    # create the price (will make sure all the rest is there)
    price = FactoryGirl.create(:price)
    store = Store.find(price.store_id)
    product = Product.find(price.product_id)

    # emulate coming from a specific store
    session[:current_store_id] = store.id

    get :show, :id => product.id

    response.should be_success

  end

  it "should upload a products feed file" do

    price = FactoryGirl.create(:price)
    store = Store.find(price.store_id)

    # emulate coming from a specific store
    session[:current_store_id] = store.id

    post :upload, :feed => @file, :feed_type => Product::PRICE_GRABBER, :store_id => store.id

    response.should redirect_to(products_path)

  end

  it "should allow getting new feed form" do

    get :new_feed

    assigns[:feed_type].should_not be_nil

    response.should be_success

  end

end
