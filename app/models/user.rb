class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable




  
  ###########################
  # Validations #############
  ###########################
  validates_presence_of :full_name
  validates_format_of :full_name, :with => /^[^0-9`!@#\$%\^&*+_=]+$/, :multiline => true
  

  # Avatar ##################
  has_attached_file :avatar,
                    :url  => "/assets/users/:id/:style/:basename.:extension",
                    :path => ":rails_root/public/assets/users/:id/:style/:basename.:extension",
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






  # def active_for_authentication?
  #   # Uncomment the below debug statement to view the properties of the returned self model values.
  #   # logger.debug self.to_yaml

  #   super && validates_full_name?
  # end

  # def validates_full_name?
  #   validates_format_of :full_name, :with => /^[^0-9`!@#\$%\^&*+_=]+$/
  #   # add any other characters you'd like to disallow inside the [ brackets ]
  #   # metacharacters [, \, ^, $, ., |, ?, *, +, (, and ) need to be escaped with a \
  # end

  
end
