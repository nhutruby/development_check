class OrganizationsController < LocationSearchController
  
  include ApplicationHelper

  #Devise Authentication
  before_filter :authenticate_user!, :except => [:tweets] 
    
  #CanCan Authorization
  load_and_authorize_resource :except => [:make_featured, :tweets]
  skip_authorization_check :only => [:make_featured, :mark_as_closed, :tweets]

  def organization_search
    @search_results = Organization.solr_search(:include => [:locations, :categorizations => [:category], :users => [:contact_methods]]) do
    #@search_results = Organization.solr_search do
      if params[:search]
        keywords "#{params[:search]}", :fields => ["name"]

        adjust_solr_params do |solr_params|
          logger.info "Adjusting solr params with spellcheck.q=#{params[:search]}"
          solr_params["spellcheck.q"] = params[:search]
        end
      else
        with :first_letter, params[:letter].first if params[:letter]
      end
      with(:association_ids, [params[:association_id]]) unless params[:association_id].nil?
      with(:is_student_friendly, params[:student]) if params[:student].present?
      with(:is_motorcoach_friendly, params[:motorcoach]) if params[:motorcoach].present?
      order_by :name, :asc
      #paginate :page => params[:page], :per_page => 10
      if params[:per_page].present?
        params[:page] ||= 1
        paginate :page => params[:page], :per_page => params[:per_page]
      end
    end
    @organizations = @search_results.results
  end

  protected :organization_search

  def index
    @association = Organization.where('id = ?', params[:association_id]).first unless params[:association_id].nil?
    if params[:letter].present? || params[:search].present?
      organization_search
      Rails.logger.debug "START **********************************************************************"
      Rails.logger.debug @search_results.inspect

      if @organizations.blank? && params[:search] && @search_results.spellcheck_collation(params[:search]).present?
        @misspelled_query = params[:search].dup
        params[:search] = @search_results.spellcheck_collation(params[:search])
        params[:letter] = nil
        organization_search
      end
    elsif @association.member_count < 101
      @organizations = @association.members.paginate(:page => params[:page], :order => 'name DESC')

    else
      @organizations = nil
    end
    @tweets = Twitter.user_timeline(@association.twitter_name).first(6) if @association.twitter_name
    rescue
  end

  def show
    @organization = Organization.find(params[:id], :include => [{:categorizations => :category}, {:locations => :address}, {:inventory_items => :price}, {:roles => {:user => :contact_methods}},  :associations, :account_type])
    #@locationOrg  = Location.find_all_by_organization_id(params[:id])
    @account_type = @organization.account_type
    @locationOrg  = @organization.locations
    @tweets = Twitter.user_timeline(@organization.twitter_name).first(3) if @organization.twitter_name
    rescue
    @items = @organization.inventory_items.order("name")
    @active = []
    @inactive = []
    for item in @items
      if item.is_active? && item.inventory_item_locations.size >  0
        @active << item
      else
        @inactive << item
      end
    end
    subscription_details
  end

  def new_interview
    @organization = Organization.new(params[:organization])
    render 'new_interview'
  end

  def new
    @organization = Organization.new(params[:organization])
    if params[:organization]
      if @organization.locations.empty?
        @location = @organization.locations.build(:is_headquarters => false, :is_active => true, :primary_contact_id => current_user.id)
        @address = @location.build_address
      end
      render 'new'
    else
      render 'new_interview'
    end
    #@organization.master_type = params[:master_type]
  end

  def create
    @organization = Organization.new(params[:organization])
      #if params[:none_is_mine].blank?
        #@organization.errors.add(:base, "You must confirm that the Organization does not currently exist")
        #render :action => 'new' and return
      #end
    @organization.owner_id = current_user.id
    @organization.creator_id = current_user.id
    @organization.primary_contact_id = current_user.id
    #moved to caallback because had to know if account_type is provider or not, because no trial is set for providers
    #@organization.trial_started_at = Time.now
    #@organization.trial_ends_at = 30.days.since(Time.now)
    if @organization.save
      if !params[:organization][:logo].blank?
        render :action => "crop"
      elsif params[:return_to]
        redirect_to params[:return_to]
      else
        redirect_to organization_url(@organization)
      end
    else
      if @organization.locations.empty?
        @location = @organization.locations.build(:is_headquarters => false, :is_active => true, :primary_contact_id => current_user.id)
        @address = @location.build_address
      else
        @location = @organization.locations.first
        @address  = @location.address
      end
      render :action => :edit
    end
  end

  def edit
    @organization = Organization.find(params[:id], :include => [:categorizations])
    #params[:claim] = true if request_action_is_claim?
    @organization.claim = true if request_action_is_claim? && @organization.owner_id == nil
    @account_type = @organization.account_type
    if @organization.locations.empty?
      @location = @organization.locations.build(:is_headquarters => true, :is_active => true, :primary_contact_id => current_user.id)
      @address = @location.build_address
    elsif request_action_is_claim?
      @location = @organization.locations.first
      @location.is_headquarters = true
      @contact_method = @location.build_contact_method(:name => "phone")
    end
  end

#  def merge_edit
#    @organization = Organization.find(params[:id])
#  end
#
#  def merge_update
#    @organization = Organization.find(params[:id])
#    #@organization.locations.each do |location|
#      #location.update_attribute(:organization_id, params[:temp_org_id])
#    #end
#    @organization.roles.each do |role|
#      role.update_attribute(:organization_id, params[:temp_org_id])
#    end
#    redirect_to organization_url(params[:temp_org_id])
#
#  end

  def update
    @organization = Organization.find(params[:id])
    subscription_details if @organization.owner_id == current_user.id
    if !params[:organization][:claim].blank?
      params[:return_to] = dashboard_path
      @organization.owner_id = current_user.id
      #@organization.creator_id = current_user.id - Not really true
      @organization.primary_contact_id = current_user.id
      #moved to caallback because had to know if account_type is provider or not, because no trial is set for providers
      #@organization.trial_started_at = Time.now
      #@organization.trial_ends_at = 30.days.since(Time.now)
      @organization.roles.build(:user_id => current_user.id, :is_admin => true, :is_organization_approved => true, :is_user_approved => true)
    elsif current_user.id
      #@organization.owner_id = current_user.id unless @organization.owner_id
      #@organization.creator_id = current_user.id unless @organization.creator_id
      #@organization.primary_contact_id = current_user.id unless @organization.primary_contact_id
      #@organization.roles.build(:user_id => current_user.id, :is_admin => true, :is_organization_approved => true, :is_user_approved => true) if @organization.roles.empty?
    end
    if @organization.update_attributes(params[:organization])
      flash[:notice] = params[:claim]
      #flash[:notice] = "Successfully updated organization."
      Rails.logger.debug params[:organization][:logo]
      if !params[:organization][:logo].blank?
        render :action => "crop"
      elsif params[:return_to]
        redirect_to params[:return_to]
      else
        redirect_to organization_url(@organization)
      end
    else
      subscription_details if @organization.owner_id == current_user.id
      render :action => :edit
    end
  end

  def destroy
    @organization = Organization.find(params[:id])
    @organization.destroy
    flash[:notice] = "Successfully destroyed organization."
    redirect_to dashboard_path
  end

  def dmo_index
    @dmos = Organization.dmas.where("organizations.name ilike ?", "%#{params[:q]}%").select("organizations.name, organizations.id")
    respond_to do |format|
      format.html
      format.json { render :json => @dmos.map(&:attributes) }
    end
  end

  def update_account_admin
    if params[:understand_upgrading].blank?
      @organization.errors.add(:base, "You must accept the signup terms")
    else
      @organization = Organization.find(params[:id])
      if @organization.update_attributes(params[:organization])
        @organization.update_attribute(:account_type_id,params[:organization][:credit_card][:account_type_id])
        @organization.update_chargify_subscription
        if @organization.errors.empty?
          if @organization.trial?
            @organization.trial_ends_at = Time.now
            @organization.save
          end
          flash[:notice] = "Account upgraded successfully. Thank you for your support!"
          redirect_to subscriptions_organization_path(@organization) and return
        end
      end
    end
    subscription_details
    product_details
    render :action => "subscriptions"
  end
  
  def mark_as_closed
    @organization = Organization.find(params[:id])
    @organization.ratings.create(:user_id => current_user.id, :is_closed => true)
    respond_to do |format|
      format.js {}
    end
  end
  
  def unmark_as_closed
    @organization = Organization.find(params[:id])
    closed = @organization.ratings.find_by_user_id(current_user.id)
    closed.destroy
    respond_to do |format|
      format.js {}
    end
  end

  def make_featured
    @organization = Organization.find(params[:id])
    @organization.is_featured ? @organization.update_attribute(:is_featured,"false") : @organization.update_attribute(:is_featured,"true")
      respond_to do |format|
        format.js {render :action => "update", :layout => false}
      end
  end

  def designate_as_member
    @organization = Organization.find(params[:id])
    @organization.association_memberships.create(:organization_id => params[:assn_id], :is_approved => true)
    respond_to do |format|
      format.js {}
    end
  end
  
  def undesignate_as_member
    @organization = Organization.find(params[:id])
    undesignated = @organization.association_memberships.find_by_organization_id(params[:assn_id])
    undesignated.destroy
    respond_to do |format|
      format.js {}
    end
  end
    

  def featured
    @organizations = Organization.featured
  end
  
  #def update_category_select
    #@organization = Organization.find(params[:id])
    #categories = Category.where(:tipe => params[:master_type]).order(:name)
      #render :partial => "categories", :locals => {:collection => categories, :organization => @organization}
  #end
  
  def cancel
    if request.xhr?
      render_as_dialog "organizations/cancel_content"
    else
      subscription_details
    end
  end
  
  def unclaim
    @organization = Organization.find(params[:id], :include => [:roles])
    # downgrade to free_plan
    @organization.cancel_chargify_subscription
    # unclaim organization
    @organization.owner_id = nil
    @organization.creator_id = nil
    @organization.primary_contact_id = nil
    #We will leave these two values to prevent a user from cheating the pay system 
    #by signing up, canceling, then signing up again to get a new free trial.
    #@organization.trial_started_at = nil
    #@organization.trial_ends_at = nil
    @organization.account_type_id = nil
    @organization.subscription_id = nil
    @organization.customer_id = nil
    # delete current_user role
    @organization.roles.where(:user_id => current_user.id).first.destroy
    if @organization.save
      flash[:notice] = "#{ @organization.name } has been cancelled."
      redirect_to dashboard_path
    else
      subscription_details
      product_details
      render :action => :subscriptions
    end
  end
  
  def transactions
    @organization = Organization.find(params[:id], :include => [:roles])
    @subscription = @organization.subscription
    @transactions = @subscription.transactions
    @transactions.sort!{|a,b| a.id <=> b.id}

    subscription_details
  end
  
  def subscriptions
    @organization = Organization.find(params[:id], :include => [:roles])
    subscription_details
    product_details
  end

  def migrate
    @organization = Organization.find(params[:id], :include => [:roles])
    product_id = AccountType.find(params[:account_type_id]).product_id
    if @organization.migrate_subscription(product_id)
      #@organization.update_chargify_subscription
      @organization.update_attribute(:account_type_id,params[:account_type_id])
      flash[:notice] = "Your subscription was changed succesfully"
      redirect_to subscriptions_organization_path(@organization)
    else
      subscription_details
      product_details
      render :action => :subscriptions
    end
  end

  def update_card
    @organization = Organization.find(params[:id], :include => [:roles])
    if @organization.update_attributes(params[:organization])
      @organization.update_chargify_subscription
      flash[:notice] = "Successfully updated credit card information"
      redirect_to subscriptions_organization_path(@organization)
    else
      subscription_details
      product_details
      render :action => :subscriptions
    end
  end

  def change_card
    product_details
    if request.xhr?
      render_as_dialog "organizations/change_card_content"
    else
      subscription_details
    end
  end
  
  def signup
    if params[:account_type_id]
      @account_type = AccountType.find(params[:account_type_id])
    elsif params[:product_id]
      @account_type = AccountType.find_by_product_id(params[:product_id])
    end
    #@selected_product = Chargify::Product.find(@account_type.product_id) if @account_type.product_id
    respond_to do |format|
      format.html do 
        if request.xhr?
          Rails.logger.debug "***********************************************************"
          Rails.logger.debug @account_type.inspect
          render_as_dialog "organizations/signup_content"
        else
          subscription_details
        end 
      end
    end
  end

  def upgrade
    @selected_account_type = AccountType.find(params[:account_type_id])
    @selected_product = Chargify::Product.find(@selected_account_type.product_id) if @selected_account_type.link_to_chargify?
    respond_to do |format|
      format.html do 
        if request.xhr?
          @current_account_type = @organization.account_type
          @product = Chargify::Product.find(@current_account_type.product_id)  if @organization.account_type.link_to_chargify?
          #@current_product = Chargify::Product.find(@organization.account_type.product_id)  if @organization.account_type.link_to_chargify?
         #@product = Subscription.product_by_handle(@organization.selected_plan)
          render_as_dialog "organizations/upgrade_content"
        else
          subscription_details
        end 
      end
    end
  end

  def list_by_trial
    if params[:query].present?
      filtered_search
    else
      Organization.send :with_exclusive_scope do
        @organizations = Organization.
          where("trial_started_at IS NOT NULL").
          order('trial_started_at DESC').
          paginate(:page => params[:page], :per_page => 10)
      end
    end
  end
    
  private
  
  def render_as_dialog(subtemplate)
    render 'generic/dialog', :layout => false, :locals => {:subtemplate => subtemplate}
  end

  def product_details
    @products = Subscription.all_products
    @subscription = @organization.subscription.reload
    @payment_profile = @subscription.payment_profile
  end

  def subscription_details
    @product = Subscription.product_by_handle(@organization.selected_plan)
    @credits_used = @organization.credits_used
    @credit_limit = @organization.credit_limit
    @percentage = ((@credits_used.to_f / @credit_limit.to_f) * 100.0)
    @percentage = @percentage.finite? ? @percentage.to_i : 0
  end

  def account_admin?
    request.referer.last(13).eql?("account/admin")
  end
end
