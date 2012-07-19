require 'csv'

# Background job that creates products from a feed
class UploadJob < Struct.new(:store_id, :feed_file, :feed_type)
  def perform
    store = Store.find_by_id(store_id)

    if feed_type == Product::PRICE_GRABBER
      upload_pricegrabber(feed_file)
    elsif feed_type == Product::SHOPPING
      upload_shopping(feed_file)
    end
  end

  def upload_shopping(feed_file)
    CSV.foreach(feed_file) do |row|
      #product = store.products.build()
      #product.save!
    end
  end

  def upload_pricegrabber(feed_file)
    CSV.foreach(feed_file) do |row|
      #product = store.products.build()
      #product.save!
    end
  end

end