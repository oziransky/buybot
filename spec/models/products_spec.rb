require 'spec_helper'

RSpec.configure do |c|
  # declare an exclusion filter
  c.filter_run_excluding :broken => true
end

describe 'Product' do
	
    fixtures :all
    
    it "is not valid without a name" do
		prod = Product.new(:name=>"",:manufacturer=>"Sony").should_not be_valid
	end
	it "is not valid without a manufacturer" do
		prod = Product.new(:name=>"some product",:manufacturer=>"").should_not be_valid
	end
    describe 'search' do
        #this test is strongly connected to the fixtures.
        #changing the fixtures may break this tests.
		it "should find by a product by name" do
           
           category = categories(:electronics)
           prod = Product.search :search=>"Tele"
           
           prod.size.should eq(2)
           assert prod[1].name.start_with?("Television")
           assert prod[0].name.start_with?("Television")
		end
		it "should filter the search results by category and manufacturer" do
           
			category = categories(:televisions)
			prod = Product.search(:search=>"Tele", 
                                 :categories=>category.id, 
                                 :manufacturer=>"Toshiba")
           
			prod.should_not be_empty
			prod[0].name.should  == "Television Toshiba"
		end
		
		it "should filter the search results by top level category" do
           
			category = categories(:electronics)
			
			prod = Product.search(:search=>"", 
                                 :categories=>category.id)
			
			prod.should_not be_empty
			product_names = prod.collect{|p| p.name}
			product_names.should  include("Television Toshiba")
			product_names.should  include("Television")
			product_names.should  include("Stereo")
			product_names.should_not  include("Red Couch")
		end
	end	 
		
		
		
	it 'should be calculate price range' do
		_products = Product.find(:all)
		range = Product.price_range(_products)
		range[0].should == 100
		range[1].should == 230
	end
        
	it 'should find all categories fo given set of tems' do
		products = [products(:product1),products(:product3),products(:product4)]
		categories = Product.all_categories products
		categories.should include(categories(:televisions))
		categories.should include(categories(:stereos))
		categories.should_not include(categories(:furniture))
	end
    
end
