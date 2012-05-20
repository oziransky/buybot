class GeneralMailer < ActionMailer::Base
  default :from => "buybot.mail@gmail.com"

  def send_friend_invite(from, email, message)
    @message = message
    @user = from
    mail(:to => "<#{email}>", :subject => "#{t(:friend_invite_subject)}")
  end

end
