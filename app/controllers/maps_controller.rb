class MapsController < LocationSearchController
  #Devise Authentication
  before_filter :authenticate_user!
    

  load_and_authorize_resource

  def index
    filtered_search if filtered_search?
    load_filter_data unless request.xhr?

    respond_to do |format|
      format.html
      format.js { render :partial => 'maps/search_result', :layout => false }
    end
  end

end

