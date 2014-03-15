class UserMailer < ActionMailer::Base
  default from: "nick@castjelly.com"
  

  # Send an email to User stating that they are registered with the site
  def registration_confirmation(user)
    @user = user
    mail(:to => "#{user.email}", :subject => "Registered")
  end
end
