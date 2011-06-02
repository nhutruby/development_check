class ApplicationController < ActionController::Base
  protect_from_forgery
  analytical :modules=>[:clicky]
  check_authorization :unless => :devise_controller?
  before_filter :update_last_seen
  before_filter :prepare_for_mobile
  helper :all

  rescue_from CanCan::AccessDenied do |exception|
    flash[:error] = exception.default_message = "You are not authorized to access that page."
    Rails.logger.debug "Access denied on #{exception.action} #{exception.subject.inspect}"
    redirect_to root_url
  end
    

  #Route user to account page upon login
  def after_sign_in_path_for(resource_or_scope)
    case resource_or_scope
    when :user, User 
       dashboard_path
    end
  end

  def after_update_path_for(resource)
    #edit_user_path(current_user)
    dashboard_path
  end
    
protected
  # blog_kit requirements
  def require_user
    authenticate_user!
  end


private

  def mobile_device?
    false
    #if session[:mobile_param]
      #session[:mobile_param] == "1"
    #else
      #request.user_agent =~ /Mobile|webOS/
    #end
  end
  helper_method :mobile_device?

  def prepare_for_mobile
    session[:mobile_param] = params[:mobile] if params[:mobile]
    request.format = :mobile if mobile_device?
  end


  def update_last_seen
    if current_user and (current_user.last_seen.nil? or current_user.last_seen < 4.minutes.ago)
      current_user.update_attribute(:last_seen, DateTime.now)
      #current_user.last_seen = DateTime.now
      #current_user.save
    end
  end


end
