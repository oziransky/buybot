class StoreOwner < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :first_name, :last_name, :password, :password_confirmation, :remember_me

  has_many :stores, :dependent => :destroy

  def get_name
    if not first_name.nil? and not last_name.nil?
      "#{first_name} #{last_name}"
    else
      "John Doe"
    end
  end
end
