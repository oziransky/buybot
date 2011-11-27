class AuctionsController < ApplicationController
  def new
    @auction = current_user.auctions.new
  end

  def create
    @auction = current_user.auctions.new(params[:auction])
    if @auction.save
      flash[:success] = "תהליך נוצר בהצלחה"
    else
      flash[:error] = "לא ניתן להתחיל תהליך"
    end

    redirect_to auctions_path
  end

  def update
    @auction = current_user.auctions.find(params[:id])
  end

  def delete
  end

  def index
    @auctions = current_user.auctions
  end

  def show
    @auctions = current_user.auctions
    @auction = current_user.auctions.find(params[:id])
  end

end
