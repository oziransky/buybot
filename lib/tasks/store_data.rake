require 'faker'
namespace :db do
  desc "Fill database with sample data"

  task :populate => :environment do
    Rake::Task['db:reset'].invoke
    10.times do |n|
      name = Faker::Name.name
      email = "example-#{n+1}@gmail.com"
      StoreOwner.create!(:name => name,
                         :email => email,
                         :password => "123456",
                         :password_confirmation => "123456")
    end

    StoreOwner.all.each do |owner|
      owner.stores.create!(:name => "Example Store",
                  :address => "Some street in some place",
                  :url => "www.stores.com",
                  :description => Faker::Lorem.sentence(2),
                  :id => owner.id)
    end
  end
end