class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  
  # Send an email when User is created 
  after_create :send_registration_confirmation
  def send_registration_confirmation
    UserMailer.registration_confirmation(self).deliver
  end
  
end
