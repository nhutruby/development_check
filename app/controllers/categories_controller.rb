class CategoriesController < InheritedResources::Base
  #Devise Authentication
  before_filter :authenticate_user!
    
  

  #CanCan Authorization
  load_and_authorize_resource

  def create
    create!{categories_url}
  end
  def update
    update!{categories_url}
  end
  
end