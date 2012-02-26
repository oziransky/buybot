require 'spec_helper'
require 'faker'

describe ProductsController do
  fixtures :all

  login_store_owner

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

end