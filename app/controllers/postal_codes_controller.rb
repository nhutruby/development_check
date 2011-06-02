class PostalCodesController < ApplicationController
  #Devise Authentication
  before_filter :authenticate_user!
    
  
  load_and_authorize_resource

  def search
    @postal_codes = PostalCode.autocomplete_search(params[:term], params[:country_code])
    respond_to do |format|
      format.js
    end
  end

  def search_city_region
    @postal_codes = PostalCode.search_city_region(params[:term])
    respond_to do |format|
      format.js
    end
  end
end