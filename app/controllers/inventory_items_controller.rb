class InventoryItemsController < ApplicationController
  #Devise Authentication
  before_filter :authenticate_user!
    
  
  load_and_authorize_resource
  
  def index
    @organization = Organization.find(params[:organization_id])
    @inventory_items = @organization.inventory_items
  end
  
  def show
    @organization = Organization.find(params[:organization_id])
    @inventory_item = @organization.inventory_items.find(params[:id])
  end
  
  def new
    @organization = Organization.find(params[:organization_id])
    @inventory_item = @organization.inventory_items.build
    @price = @inventory_item.build_price(:currency => 'usd')
  end
  
  def create
    @organization = Organization.find(params[:organization_id])
    @inventory_item = @organization.inventory_items.build(params[:inventory_item])
    if @inventory_item.save
      flash[:notice] = "Successfully created inventory item."
      redirect_to organization_inventory_item_path(@organization, @inventory_item)
    else
      render :action => 'new'
    end
  end
  
  def edit
    @organization = Organization.find(params[:organization_id])
    @inventory_item = @organization.inventory_items.find(params[:id])
    @price = @inventory_item.build_price(:currency => 'usd') unless @inventory_item.price
  end
  
  def update
    @organization = Organization.find(params[:organization_id])
    @inventory_item = @organization.inventory_items.find(params[:id])
    if @inventory_item.update_attributes(params[:inventory_item])
      flash[:notice] = "Successfully updated inventory item."
      redirect_to organization_inventory_item_path(@organization, @inventory_item)
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @organization = Organization.find(params[:organization_id])
    @inventory_item = @organization.inventory_items.find(params[:id])
    @inventory_item.destroy
    flash[:notice] = "Successfully destroyed inventory item."
    redirect_to @organization
  end
end
