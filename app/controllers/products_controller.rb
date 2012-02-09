# encoding: utf-8
class ProductsController < ApplicationController
  def new
    @store = get_store
    @product = @store.products.new
    @product.prices << @store.prices.build
  end

  def create
    @store = get_store
    @product = @store.products.build(params[:product])
    if @product.save
      flash[:success] = "Product created successfully"
    else
      flash[:error] = "Unable to create a product"
    end

    redirect_to products_path
  end

  def update
    @product = Product.find(params[:id])
    if @product.update_attributes!(params[:product])
      flash[:success] = "Product updated."
      redirect_to @product
    else
      flash[:error] = "Unable to update product."
      render 'edit'
    end
  end

  def edit
    @store = get_store
    @product = Product.find(params[:id])
  end

  def show
    @store = get_store
    @product = @store.products.find(params[:id])
  end

  def index
    @store = get_store
    @products = @store.products.paginate(:per_page => 15, :page => params[:page])
  end

  def destroy
    @store = get_store
    @product = @store.products.find(params[:id])
    if @product.destroy
      flash[:success] = "Product updated."
      redirect_to products_path
    else
      flash[:error] = "Unable to delete product."
      render @product
    end
  end

  private

  def get_store
    Store.find_by_id(session[:current_store_id])
  end

end
