class MembershipsController < InheritedResources::Base
  #Devise Authentication
  before_filter :authenticate_user!
    
  load_and_authorize_resource
  
  def mark
    @organization = Organization.find(params[:id])
    association_id = params[:association_id]
      @membership = @organization.association_memberships.find_by_organization_id(association_id)
    if params[:task] == "remove"
      
      Rails.logger.debug "START **********************************************************************"
      Rails.logger.debug @membership.inspect
      
      
      
      @membership.is_organization_approved = "false"
      @membership.save
    elsif params[:task] == "add"
      unless @membership.blank?
        @membership.is_organization_approved = true
        @membership.save
      else                
        @organization.memberships.create(:organization_id => association_id)
      end
    end
    respond_to do |format|
      format.js {}
    end
  end  
end
