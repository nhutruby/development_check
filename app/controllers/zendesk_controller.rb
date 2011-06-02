require "digest/md5"

class ZendeskController < ApplicationController
  
#from zendesk help desk

skip_authorization_check

  def index
    @zendesk_remote_auth_url = ZENDESK_REMOTE_AUTH_URL
  end

  def login
    timestamp = params[:timestamp] || Time.now.utc.to_i
    # hard coded for example purposes
    # really you would want to do something like current_user.name and current_user.email
    # and you'd probably want this in a helper to hide all this implementation from the controller
    name = current_user.full_name
    email = current_user.email
    string = name + email + ZENDESK_REMOTE_AUTH_TOKEN + timestamp.to_s
    #string = "First Last" + "first.last@gmail.com" + ZENDESK_REMOTE_AUTH_TOKEN + timestamp
    hash = Digest::MD5.hexdigest(string)
    @zendesk_remote_auth_url = "http://itoursmart.zendesk.com/access/remote/?name=#{name}&email=#{email}&timestamp=#{timestamp}&hash=#{hash}"
    redirect_to @zendesk_remote_auth_url
  end

  def logout
    flash[:notice] = params[:message]
  end
end