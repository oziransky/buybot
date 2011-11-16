class StoresController < ApplicationController

  def new
    @store = current_store_owner.stores.create(params[:stores])
    if @store.save
      flash[:success] = "חנות נוצרה בהצלחה"
    else
      flash[:error] = "לא ניתו ליצור את החנות"
    end

    # Go to the store summary page
    redirect_to stores_path
  end

  def index
    @stores = current_store_owner.stores
    #@stores = Store.paginate(:page => params[:page])
  end

  def show
    @stores = current_store_owner.stores
    @store = @stores.find(params[:id])
  end

  def update

  end

  def destroy
    @store.destroy
    redirect_back_or store_path
  end

end
