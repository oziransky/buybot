class SearchResults

  attr_accessor :prod_categories, :manufacturers, :price_range, :products

  def initialize(products,prod_categories,manufacturers)
    @prod_categories = prod_categories
    @manufacturers = manufacturers
    @price_range = []
    @products = products
  end

end