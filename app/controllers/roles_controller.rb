class RolesController < ApplicationController
  #Devise Authentication
  before_filter :authenticate_user!
    
  #Call Layout Template
  
  
  #CanCan Authorization
  load_and_authorize_resource
  skip_authorization_check :only => [:user_approve]

  def unset_admin
    @role = Role.find(params[:id])
    @role.update_attribute(:is_admin, false)
    flash[:notice] = "Admin privileges were removed for #{@role.user.full_name}"
    redirect_to :back
  end

  def set_admin
    @role = Role.find(params[:id])
    @role.update_attribute(:is_admin, true)
    flash[:notice] = "Admin privileges were added for #{@role.user.full_name}"
    redirect_to :back
  end

  
  def index
    @organization = Organization.find(params[:organization_id])
    @roles = @organization.roles(:include => :user)
    @roles_needing_org_approval = @organization.roles(:include => :user).not_org_approved
    @roles_needing_user_approval = @organization.roles(:include => :user).not_user_approved
    @roles_approved = @organization.roles(:include => :user).approved
    authorize! :update, @organization
  end
  
  def add_to_organization
    @role = Role.new(:user_id => params[:user_id], :organization_id => params[:organization_id], :is_organization_approved => true)
    #@role.user_id = params[:user_id]
    #@role.organization_id = params[:organization_id]
    #@role.is_organization_approved = true
    if @role.save
      @note = Note.new(:permalink => "invitation", :is_sysmessage => true, :subject => "Join the #{@role.organization.name} team!")
      @note.recipients.build(:user_id => @role.user_id, :role_id => @role.id)
      @note.save
      redirect_to dashboard_path
    end
  end
  
  def organization_approve
    @role = Role.find_by_id(params[:id])
    if !@role.is_organization_approved?
      @role.is_organization_approved = true
      @role.save
      flash[:notice] = "#{@role.user.full_name} has been added to the team"
      redirect_to params[:return_to] || dashboard_path
    else
      flash[:notice] = "#{@role.user.full_name} is already on the team"
      redirect_to params[:return_to] || dashboard_path
    end      
  end

  def organization_decline
    @role = Role.find_by_id(params[:id])
    @role.update_attribute(:is_organization_approved, false)
    flash[:notice] = "You have declined the request from #{@role.user.full_name}"
    redirect_to params[:return_to] || dashboard_path
  end

  def user_approve
    @role = Role.find_by_id(params[:id])
    @role.is_user_approved = true
    @role.save
    @recipient = Recipient.find_by_role_id(@role.id)
    @note = @recipient.note
    @recipient.destroy
    @note.destroy if @note
    flash[:notice] = "Your role has been approved"
    redirect_to dashboard_path
  end

  def user_decline
    @role = Role.find_by_id(params[:id])
    @role.is_user_approved = false
    @role.save
    @recipient = @role.recipient
    @note = @recipent.note
    @recipient.destroy
    @note.destroy
    flash[:notice] = "You have declined the invitation"
    redirect_to dashboard_path
  end


  def add_to_organization_unapproved
    @organization = Organization.find_by_id(params[:organization_id])
    if @organization.can_add_team_member?
      @role = Role.new(params[:role])
      @role.user_id = current_user.id
      @role.organization_id = @organization.id
      @role.is_user_approved = true
      if @role.save
        user = @role.user
        owner_id = @organization.owner_id
        @note = Note.new(:sender_id => user.id, :subject => "#{user.full_name} has asked to join your team!", :permalink => "user_request", :is_sysmessage => false)
        @recipient = @note.recipients.build(:user_id => owner_id, :role_id => @role.id)
        @note.save
        if @recipient.user.email_messages == true
          SystemMessageMailer.new_message_email(@recipient).deliver
        end
        flash[:notice] = "Your request to join the #{@organization.name} team has been sent."
        redirect_to dashboard_path
      end
    else
      admins = @organization.owner.full_name
      flash[:notice] = "Please contact #{admins} about upgrading your account"
      redirect_to organization_url(@organization)
    end
  end

  def remove_from_organization
    @role = Role.find(params[:id])
    @role.update_attribute(:is_organization_approved, false)
    redirect_to :back
  end
end
