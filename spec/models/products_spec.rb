require 'spec_helper'

describe 'Product model' do
    
    fixtures :categories, :products
    
    describe 'search' do
        #this test is strongly connected to the fixtures.
        #changing the fixtures may break this tests.
       it "should find by prodct by name" do
           
           category = categories(:electronics)
           prod = Product.search :search=>"Tele", 
                                 :categories=>category.id, 
                                 :manufacturer=>"Toshiba"
           
           prod.should_not be_empty
           prod[0].name  == "Television2"
       end 
        
    end
    
end
