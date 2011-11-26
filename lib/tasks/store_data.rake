require 'faker'



def create_categories_and_products
  subcategories = []
  5.times do |c|
    category = Category.create!(:name => "Electronics#{c+1}")
    10.times do |s|
      sub_category = category.children.create!(:name => "Sub#{c+1}_#{s+1}")
      subcategories << sub_category
    end
  end

  100.times do |n|
    product = Product.create!(:name => "Product#{n+1}",
    :description => Faker::Lorem.sentence(4),
    :url => "www.monster.com",
    :catalog_id => 1,
    :image_folder => "public/data/p#{n+1}",
    :manufacturer => @manufacturers[rand(@manufacturers.size)])
    3.times do
      product.categories << subcategories[rand(subcategories.size)]
    end
    product.save
  end
end



def create_stores_owners
  10.times do |n|
    name = Faker::Name.name
    email = "example-#{n+1}@gmail.com"
    StoreOwner.create!(:name => name,
    :email => email,
    :password => "123456",
    :password_confirmation => "123456")
  end
end



def create_stores_and_inventory
  #for each store owner add a store
  StoreOwner.all.each do |owner|
    @store = owner.stores.create!(:name => "Example Store",
    :address => "Some street in some place",
    :url => "www.stores.com",
    :description => Faker::Lorem.sentence(2),
    :store_owner_id => owner.id)

    #for each store add some products to the store
    3.times do |n|

      @product = Product.all[rand(Product.count)]
      @store.prices.create!(:price => 1.2,
      :product_id => @product.id,
      :store_id => @store.id)
    end
  end
end


namespace :db do
  desc "Fill database with sample data"

  @manufacturers = ["Sony","Toshiba","Apple","Panasocnic"]

  task :populate => :environment do
    Rake::Task['db:reset'].invoke

    create_categories_and_products

    create_stores_owners

    create_stores_and_inventory

  end
end