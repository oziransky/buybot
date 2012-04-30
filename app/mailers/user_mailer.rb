class UserMailer < ActionMailer::Base
  default :from => "buybot.mail@gmail.com"

  def registration_confirm(user)
    @user = user
    mail(:to => "#{user.name} <#{user.email}>", :subject => "Registered")
  end

  def auction_updated(user, auction)
    @user = user
    @auction = auction
    mail(:to => "#{user.first_name} <#{user.email}>", :subject => "Auction price updated - #{auction.current_price} !")
  end

end
