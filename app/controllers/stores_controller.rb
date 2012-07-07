# encoding: utf-8 
class StoresController < ApplicationController

  def new
    @store = current_store_owner.stores.new
  end

  def create
    @store = current_store_owner.stores.build(params[:store])
    if @store.save
      flash[:success] = "Your store was created."
    else
      flash[:error] = "Unable to create a store."
    end

    redirect_to stores_path
  end

  def index
    @stores = current_store_owner.stores

    redirect_to @stores[0] if @stores.count == 1
  end

  def show
    @stores = current_store_owner.stores
    @store = @stores.find(params[:id])
    session[:current_store_id] = @store.id
  end

  def edit
    @stores = current_store_owner.stores
    @store = @stores.find(params[:id])
  end

  def update
    @stores = current_store_owner.stores
    @store = @stores.find(params[:id])

    if @store.update_attributes!(params[:store])
      flash[:success] = "Store updated."

      respond_to do |format|
        format.html { redirect_to @store }
        format.js { render :js => "window.location = '/stores/#{@store.id}'" }
      end
    else
      flash[:error] = "Unable to update store."
      render 'edit'
    end
  end

  def destroy
    @stores = current_store_owner.stores
    @store = @stores.find(params[:id])
    if @store.destroy
      flash[:success] = "Your store was deleted."
      redirect_to stores_path
    else
      flash[:error] = "Unable to delete a store."
      redirect_to @store
    end
  end

end
