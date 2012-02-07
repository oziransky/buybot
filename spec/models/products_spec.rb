require 'spec_helper'

describe 'Product model' do
	
    fixtures :categories, :products
    
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
           
			category = categories(:electronics)
			prod = Product.search :search=>"Tele", 
                                 :categories=>category.id, 
                                 :manufacturer=>"Toshiba"
           
			prod.should_not be_empty
			prod[0].name  == "Television2"
		end 
		it "product is not valid without a name" do
			prod = Product.new(:name=>"",:manufacturer=>"Sony").should_not be_valid
		end
		it "product is not valid without a manufacturer" do
			prod = Product.new(:name=>"some product",:manufacturer=>"").should_not be_valid
		end
        
    end
    
end
