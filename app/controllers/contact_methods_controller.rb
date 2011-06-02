class ContactMethodsController < ApplicationController
  #Devise Authentication
  before_filter :authenticate_user!
    
  

  #CanCan Authorization
  load_and_authorize_resource
  
  def new
    @contact_method = Contact_Method.new
  end
  
  
  
end
