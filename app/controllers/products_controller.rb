# encoding: utf-8
class ProductsController < ApplicationController
  def new
    @store = Store.find_by_id(session[:current_store_id])
    @product = @store.products.new
  end

  def create
    @store = Store.find_by_id(session[:current_store_id])
    @product = @store.products.create!(params[:products])
    if @product.save
      flash[:success] = "מוצר נוצר בהצלחה"
      @price = @store.prices.create!(:price => 1.5,
                                            :product_id => @product.id)
    else
      flash[:error] = "לא ניתו ליצור את מוצר"
    end

    redirect_to products_path
  end

  def update
  end

  def show
    @store = Store.find_by_id(session[:current_store_id])
    @products = @store.products
    @product = @products.find(params[:id])
  end

  def index
    @store = Store.find_by_id(session[:current_store_id])
    @products = @store.products
  end
end
