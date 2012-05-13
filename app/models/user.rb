class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :timeoutable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :first_name, :last_name, :password, :password_confirmation, :remember_me, :fb_uid

  has_many :auctions, :dependent => :destroy
  has_many :auction_histories, :dependent => :destroy
  has_one :facebook_info

  def display_name
    email
  end

  def self.find_or_create(fb_user)
    user = User.find_all_by_fb_uid(fb_user.identifier).first
    if user.nil?
      pass = Devise.friendly_token[0, 10]
      user = User.create(:email => fb_user.email, :password => pass, :password_confirmation => pass)
    end
      user.fb_uid = fb_user.identifier
      user.access_token = fb_user.access_token.access_token
      user.save!
      user
  end

  def online?
    updated_at > 10.minutes.ago
  end
end
