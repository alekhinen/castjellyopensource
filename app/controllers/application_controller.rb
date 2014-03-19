class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  # Force user to be redirected to login page if not logged in
  before_action :authenticate_user!

  before_action :configure_devise_permitted_parameters, if: :devise_controller?

  protected

  # Permitted parameters for various actions
  def configure_devise_permitted_parameters
    registration_params = [:full_name, :email, :password, :password_confirmation]

    if params[:action] == 'update'
      devise_parameter_sanitizer.for(:account_update) { 
        |u| u.permit(registration_params << :current_password, :full_name)
      }
    elsif params[:action] == 'create'
      devise_parameter_sanitizer.for(:sign_up) { 
        |u| u.permit(registration_params << :full_name) 
      }
    end
  end
end
