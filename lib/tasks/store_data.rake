require 'faker'
namespace :db do
  desc "Fill database with sample data"

  task :populate => :environment do
    Rake::Task['db:reset'].invoke

    10.times do |c|
      category = Category.create!(:name => "Electronics#{c+1}")
      5.times do |s|
        category.children.create!(:name => "Sub#{c+1}_#{s+1}")
      end
    end

    #create store owners
    10.times do |n|
      name = Faker::Name.name
      email = "example-#{n+1}@gmail.com"
      StoreOwner.create!(:name => name,
                         :email => email,
                         :password => "123456",
                         :password_confirmation => "123456")
    end

    # create some products
    products = []
    20.times do |p|
      products.insert(0, Product.create!(:name => "Product#{p+1}",
                                         :description => Faker::Lorem.sentence(4),
                                         :url => "www.monster.com",
                                         :catalog_id => 1,
                                         :image_folder => "public/data/p#{p+1}",
                                         :manufacturer => "Sony"))
    end

    # for each store owner add a store
    StoreOwner.all.each do |owner|
      #owner.stores.create!(:name => "Example Store",
      #            :address => "Some street in some place",
      #            :url => "www.stores.com",
      #            :description => Faker::Lorem.sentence(2),
      #            :id => owner.id)
      @store = owner.stores.create!(:name => "Example Store",
                                    :address => "Some street in some place",
                                    :url => "www.stores.com",
                                    :description => Faker::Lorem.sentence(2),
                                    :store_owner_id => owner.id)

      # for each store add some products to the store
      3.times do |n|
        product = products[rand(19)]
        @store.products.push(product)
        @store.prices.create!(:price => 1.2,
                              :product_id => product.id,
                              :store_id => @store.id)
        #@product = @store.products.create!(:name => "Product#{n+1}",
        #                              :description => Faker::Lorem.sentence(4),
        #                              :url => "www.monster.com",
        #                              :catalog_id => 1,
        #                              :image_folder => "public/data/p#{n+1}",
        #                              :manufacturer => "Sony")
        #
        #@store.prices.create!(:price => 1.2,
        #                      :product_id => @product.id,
        #                      :store_id => @store.id)
      end
    end
  end
end