require 'spec_helper'

describe CustomerProductsController, "searching for a product" do
    
    fixtures :all
    describe "search" do
        it "should pass the parameters to 'find' method" do
            @all_products = Product.all
            search_params = {:search=>"product1", :categories=>nil, :manufacturer=>nil, :price_range=>nil}
            product = mock_model Product
            Product.should_receive('search').with(search_params).and_return(@all_products)
            get :search, :search=>"product1"
        end
        
        it 'should find all categories of the search result' do
            search_params = {:search=>"product1", :categories=>nil, :manufacturer=>nil, :price_range=>nil}
            @all_products = Product.all
            categories = [mock_model(Category),mock_model(Category)]
            manufacturers = ["Sony","Toshiba"]
            price_range = [100,300]
            Product.should_receive('search').with(search_params).and_return(@all_products)
            Product.should_receive('all_categories').with(@all_products).and_return(categories)
            Product.should_receive('all_manufacturers').with(@all_products).and_return(manufacturers)
            Product.should_receive('price_range').with(@all_products).and_return(price_range)
            get :search, :search=>"product1"
            assigns[:prod_categories].should eq(categories)
            assigns[:manufacturers].should eq(manufacturers) 
            assigns[:price_range].should ==  price_range

        end
    end
    
     
end
