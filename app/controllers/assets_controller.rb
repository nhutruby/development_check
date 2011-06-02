class AssetsController < InheritedResources::Base
  #Devise Authentication
  before_filter :authenticate_user!
    
  load_and_authorize_resource

  def index
    @organization = Organization.find(params[:organization_id])
    @assets = @organization.assets
    
  end

  def new
    @organization = Organization.find(params[:organization_id])
    @asset = Asset.new(:organization_id => @organization.id)
  end

  def create
    @organization = Organization.find(params[:asset][:organization_id])
    @asset = @organization.assets.build(params[:asset])
    if @asset.save
      flash[:notice] = "Successfully created file."
      redirect_to organization_path(@organization)
    else
      render :action => 'new'
    end
  end

  def edit
    @asset = Asset.find(params[:id])
    @organization = @asset.assetable if @asset.assetable_type = "Organization"
  end

  def update
    @asset = Asset.find(params[:id])
    @organization = @asset.assetable if @asset.assetable_type = "Organization"
    if @asset.update_attributes(params[:asset])
      flash[:notice] = "Successfully updated file."
      redirect_to organization_path(@organization)
    else
      render :action => 'edit'
    end
  end
  def destroy
    destroy!{organization_path}
  end

end
