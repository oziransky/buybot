class StoreOwnerMailer < ActionMailer::Base
  STARTED = 0
  UPDATED = 1
  DROPPED = 2

  default :from => "buybot.mail@gmail.com"

  def auction_updated(store_owner, auction)
    send_email(store_owner, auction, t(:auction_updated, :status=>auction.status_to_s))
  end

  def auction_started(store_owner, auction)
    send_email(store_owner, auction, t(:auction_started))
  end

  def store_dropped(store_owner, auction)
    send_email(store_owner, auction, t(:store_dropped))
  end

  private

  def send_email(store_owner, auction, subject)
    @store_owner = store_owner
    @auction = auction
    mail(:to => "#{store_owner.first_name} <#{store_owner.email}>", :subject => subject)
  end
end
