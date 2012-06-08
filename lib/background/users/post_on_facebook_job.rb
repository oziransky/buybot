require 'log4r'
include Log4r
class PostOnFacebookJob < Struct.new(:user_id, :product_id, :price,:store_id)


  def perform
    logger = Log4r::Logger[Rails.env]

    user = User.find user_id

    fb_profile = Facebook.profile user.access_token
    name = fb_profile.name
    product = Product.find(product_id).name
    store = Store.find(store_id).name
    message = "#{name} just bought #{product} only for #{price} NIS from #{store}"
    fb_profile.feed!(:message=>message)

  end

end