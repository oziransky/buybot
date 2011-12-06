# encoding: utf-8
require 'faker'



def create_categories_and_products(num_of_categories,num_of_sub, num_of_products)
  subcategories = []
  Category.create!(:name => "מכשירי חשמל")
  Category.create!(:name => "רהיטים")
  Category.create!(:name => "לגן")
  
  
  3.times do |c|
    category = Category.find(c+1)
    num_of_sub.times do |s|
      sub_category = category.children.create!(:name => category.name + "#{s+1}")
        num_of_sub.times do |ss|
          sub_sub_category = sub_category.children.create!(:name => category.name + "#{s+1}_#{ss+1}")
          subcategories << sub_sub_category
        end
    end
  end

  num_of_products.times do |n|
    product = Product.create!(:name => "Product#{n+1}",
              :description => Faker::Lorem.sentence(4),
              :url => "www.monster.com",
              :catalog_id => 1,
              :image_folder => "public/data/p#{n+1}",
              :manufacturer => @manufacturers[rand(@manufacturers.count - 1)])
    3.times do
      product.categories << subcategories[rand(subcategories.count - 1)]
    end
  end
end



def create_stores_owners(num_of_owners)
  puts "creating " + num_of_owners.to_s + " store owners"
  num_of_owners.times do |n|
    name = Faker::Name.name
    email = "example-#{n+1}@gmail.com"
    StoreOwner.create!(:name => name,
    :email => email,
    :password => "123456",
    :password_confirmation => "123456")
  end
end



def create_stores_and_inventory()
  puts "createing stores and inventory"
  puts "products created "+Product.count.to_s
  puts "store owners created "+StoreOwner.count.to_s
  products = Product.all
  puts products.count
  storeowners = StoreOwner.all
  puts storeowners.count
  storeowners.each do |owner|
    @store = owner.stores.create!(:name => "Example Store",
    :address => "Some street in some place",
    :url => "www.stores.com",
    :description => Faker::Lorem.sentence(2),
    :store_owner_id => owner.id)

    #for each store add some products to the store 
    100.times do |n|

      @product = products[rand(products.count)]
      @store.prices.create!(:price => 1.2,
      :product_id => @product.id,
      :store_id => @store.id)
    end
  end
end


namespace :db do
  desc "Fill database with sample data"

  @manufacturers = ["Sony","Toshiba","Apple","Panasocnic"]
  number_of_categories = 3
  number_of_sub_categories = 4
  num_of_products = 120
  num_of_owners = 10
 
  task :populate => :environment do
    Rake::Task['db:reset'].invoke

    create_categories_and_products(number_of_categories, number_of_sub_categories,num_of_products)

    create_stores_owners(num_of_owners)

    create_stores_and_inventory()

  end
end
