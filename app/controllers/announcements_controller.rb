class AnnouncementsController < InheritedResources::Base
  #Devise Authentication
  before_filter :authenticate_user!
    
  
  load_and_authorize_resource


  def create
    create!{announcements_url}
  end
  def update
    update!{announcements_url}
  end


end
