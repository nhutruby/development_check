class PricesController < ApplicationController
  #Devise Authentication
  before_filter :authenticate_user!
    
  #Call Layout Template
  
  
  #CanCan Authorization
  load_and_authorize_resource
end

