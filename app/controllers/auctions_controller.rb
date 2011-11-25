# encoding: utf-8
class AuctionsController < ApplicationController
  def new
    @auction = Auction.create!(params[:auctions])
    if @auction.save
      flash[:success] = "תהליך נותר בהצלחה"
    else
      flash[:error] = "לא ניתן להתחיל תהליך"
    end

    redirect_to auctions_path
  end

  def update
  end

  def delete
  end

  def show
  end

  def index
  end

end
