class StoreOwnerMailer < ActionMailer::Base
  STARTED = 0
  UPDATED = 1

  default :from => "buybot.mail@gmail.com"

  def auction_started(store_owner, auction)
    @store_owner = store_owner
    mail(:to => "#{store_owner.first_name} <#{store_owner.email}>", :subject => "Auction started")
  end

  def auction_updated(store_owner, auction)
    @store_owner = store_owner
    @auction = auction
    mail(:to => "#{store_owner.first_name} <#{store_owner.email}>", :subject => "Auction updated")
  end
end
