class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Many-to-many relationship between users and podcasts
  has_many :subscriptions
  has_many :podcasts, :through => :subscriptions

  # Many-to-many relationship between users and shows
  has_many :saves
  has_many :shows, :through => :saves


  
  ###########################
  # Validations #############
  ###########################
  validates_presence_of :full_name
  validates_format_of :full_name, :with => /^[^0-9`!@#\$%\^&*+_=]+$/, :multiline => true
  

  # Avatar ##################
  has_attached_file :avatar,
                    :default_url => "/assets/default_avatar.png"
  validates_attachment_size :avatar, :less_than => 250.kilobytes
  validates_attachment_content_type :avatar, :content_type => ['image/jpeg', 'image/png']


  ###########################
  # Emails ##################
  ###########################
  # Send an email when User is created 
  after_create :send_registration_confirmation
  def send_registration_confirmation
    UserMailer.registration_confirmation(self).deliver
  end


  
end
