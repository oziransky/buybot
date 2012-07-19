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
    @price = 0
    @product.prices.each do |price|
      if price.store_id == @store.id
        @price = price.price
      end
    end
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

  def new_feed
    @store = get_store
    @feed_type = Product.get_feeds
  end

  def upload
    uploaded_io = params[:feed]

    file_path = Rails.root.join("public", "uploads", "#{Time.now.to_i}_#{uploaded_io.original_filename}")

    File.open(file_path, 'w') do |file|
      file.write(uploaded_io.read)
    end

    # create a background job to read and create the products
    Delayed::Job.enqueue(UploadJob.new(params[:store_id], file_path, params[:feed_type]))

    flash[:success] = "Feed file was successfully uploaded"

    redirect_to products_path
  end

  private

  def get_store
    Store.find_by_id(session[:current_store_id])
  end

end
