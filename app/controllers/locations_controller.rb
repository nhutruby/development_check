class LocationsController < LocationSearchController
  #Devise Authentication
  before_filter :authenticate_user!
    
  
  load_and_authorize_resource


  def index
    @organization = Organization.find(params[:organization_id])
    @locations = @organization.locations
    
  end
  
  def show
    @organization = Organization.find(params[:organization_id])
    @location = @organization.locations.find(params[:id])
    @locationOrg  = Location.find_by_id(params[:id])
  end
  
  def new
    @organization = Organization.find(params[:organization_id])
    @location = @organization.locations.build(:is_active => true, :primary_contact_id => current_user.id)
    @address = @location.build_address
    @contact_method = @location.build_contact_method(:name => "phone")
  end
  
  def create
    @organization = Organization.find(params[:organization_id])
    @location = @organization.locations.build(params[:location])
    if @location.save
      flash[:notice] = "Successfully created location."
      redirect_to organization_location_path(@organization,@location)
    else
      render :action => 'new'
    end
  end
  
  def edit
    @organization = Organization.find(params[:organization_id])
    @location = @organization.locations.find(params[:id])
    @address = @location.build_address unless @location.address
    @contact_method = @location.build_contact_method(:name => "phone") unless @location.contact_method
  end
  
  def update
    @organization = Organization.find(params[:organization_id])
    @location = @organization.locations.find(params[:id])
    if @location.update_attributes(params[:location])
      flash[:notice] = "Successfully updated location."
      redirect_to organization_location_path(@organization,@location)
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @organization = Organization.find(params[:organization_id])
    @location = @organization.locations.find(params[:id])
    count = Location.find_all_by_organization_id(@location.organization_id).size
    if count > 1
      @location.destroy
      flash[:notice] = "Successfully destroyed location."
      redirect_to @organization
    else
      flash[:notice] = "Could not destroy the only location."
      redirect_to @organization
    end     
  end
  
  def list_by_accuracy
    if params[:query].present?
      filtered_search
    else
      Location.send :with_exclusive_scope do
        @locations = Location.includes(:address, :organization).
          order('addresses.accuracy ASC').
          paginate(:page => params[:page], :per_page => 10)
      end
    end
  end
  
  def geocode
    geocode = Location.geocode(params[:address])
    h = {
      :success => geocode.success,
      :lat => geocode.lat,
      :lng => geocode.lng,
      :accuracy => geocode.accuracy
    }
    respond_to do |format|
      format.js { render :json => h }
    end
  end
end