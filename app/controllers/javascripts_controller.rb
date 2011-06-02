class JavascriptsController < ApplicationController
  skip_authorization_check

  def hide_announcement
    time = Time.now.utc
    set_session time
    set_cookies time
    respond_to do |format|
      format.html { redirect_to(user_path(current_user)) }
      format.js
    end
  end 
  

  private
    def set_session(time)
      session[:announcement_hide_time] = time
    end
    #TODO change expiration time to be the expiration 
    #date from the list in current_announcements
    def set_cookies(time)
      cookies[:announcement_hide_time] = {
        :value => time.to_datetime.to_s,
        :expires => time.next_week
      }
    end
end
