# encoding: utf-8 
class StoresController < ApplicationController

  def new
    @store = current_store_owner.stores.new
  end

  def create
    @store = current_store_owner.stores.new(params[:stores])
    if @store.save
      flash[:success] = "Your store was created!"
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

  def update

  end

  def destroy
    @store.destroy
    redirect_back_or store_path
  end

end
