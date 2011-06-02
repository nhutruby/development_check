class UsersController < LocationSearchController
  #CanCan Authorization
  load_and_authorize_resource
    
  
  def index
    per_page = request.xhr? ? 8 : 20
    @search_results = User.solr_search do
      keywords params[:term], :fields => [:name_first, :name_last] do
        boost(2.0) do
          with(:connection_ids, current_user.id)
        end
      end
      without(:id, current_user.id)
      without(:sign_in_count, 0)
      paginate :page => params[:page], :per_page => per_page
    end

    @users = @search_results.results
    @total = @users.total_entries

    respond_to do |format|
      format.html
      format.js
    end
  end

  def dashboard
    @user = @user = User.find(current_user.id, :include => [{:recipients => :note}, :connections, {:roles => {:organization => :memberships}}])
    account_type_ids = Array.new
    account_type_ids = @user.organizations.collect{|u| u.account_type_id}
    @account_types = AccountType.find(account_type_ids)
    if params[:association_id].nil? && session[:association_id]
      params[:association_id] = session[:association_id]
    end
    session[:association_id] = params[:association_id]
    authorize! :manage, @user

    if filtered_search?
      filtered_search
      if !params[:query].blank?
        if @locations.blank? && @search_results.spellcheck_collation(params[:query]).present?
          @misspelled_query = params[:query].dup
          params[:query] = @search_results.spellcheck_collation(params[:query])
          filtered_search
        end
      end
    else
      @locations = Location.from_featured_organizations.limit(10).all.paginate
    end

    load_filter_data unless request.xhr?

    respond_to do |format|
      format.html #{ render :layout => 'application' }
      format.js   { render :partial => 'users/search_result', :layout => false }
    end
  end


  def show
    @user = User.find(params[:id], :include => [:connections, {:roles => [:organization]}])
    respond_to do |format|
      format.html #{ render :layout => 'maps' }
      format.js   { render :partial => 'users/search_result', :layout => false }
    end
  end

  def new
    @user = User.new
    @user.contact_methods.build(:name => "phone") unless @user.contact_methods.phone
    respond_to do |format|
      format.html # new.html.haml
      format.xml  {render :xml => @user }
    end
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      flash[:notice] = "Successfully created user."
      if params[:user][:avatar].blank?
      redirect_to @user
      else
        render :action => "crop"
      end
    else
      render :action => 'new'
    end
  end

  def edit
    @user = User.find(params[:id])
    
    #ADD Address/phone/email functionality
    @user.contact_methods.build(:name => "phone") unless @user.contact_methods.phone.count > 0 
  end

  def edit_email_preferences
    @user = User.find(params[:id])
    #ADD Address/phone/email functionality
    #@user.contact_methods.build(:name => "phone") unless @user.contact_methods
    render 'edit_email_preferences'
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(params[:user])
      flash[:notice] = "Successfully updated user."
      if params[:user][:avatar].blank?
      redirect_to current_user
      else
        render :action => "crop"
      end
    else
      render :action => 'edit'
    end
  end

  def destroy
    @user = User.find(params[:id])
    if !@user.owned_organizations
      if @user.update_attributes(:is_deleted => true, :is_active => false)
        #PCTODO Destroy child records as appropriate and update queries
        @user.roles.destroy_all
        @user.connectionships.destroy_all
        @user.contact_methods.destroy_all
        @user.ratings.destroy_all
        flash[:notice] = "Successfully destroyed user."
        redirect_to destroy_user_session_path

      else
        render :action => 'edit'
      end
    else
      flash[:notice] = "Please change the owner of your company before deleting your account."
      redirect_to dashboard_path
    end
  end

  def search
    @search_results = User.solr_search do
      keywords "#{params[:search_user_query]}", :fields => [:name_first, :name_last] do
        boost(2.0) do
          with(:connection_ids, current_user.id)
        end
      end
      without(:id, current_user.id)
      paginate :page => params[:page], :per_page => 8
    end

    @users = @search_results.results

    respond_to do |format|
      format.html
      format.js
    end
  end
  

end