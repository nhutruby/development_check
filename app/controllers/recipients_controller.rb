class RecipientsController < ApplicationController
  #Devise Authentication
  before_filter :authenticate_user!
    

  #CanCan Authorization
    load_and_authorize_resource
    skip_authorization_check :only => [:fancybox_show]
  
  # GET /recipients
  # GET /recipients.xml
  def index
    @user = current_user
    @recipients = Recipient.where(:user_id => current_user.id).includes(:note)
    respond_to do |format|
      format.html # index.html.haml
      format.xml  { render :xml => @recipients }
    end
  end

  # GET /recipients/1
  # GET /recipients/1.xml
  def show
    @recipient = Recipient.find(params[:id])
    @recipient.update_attributes(:is_read => true)

    respond_to do |format|
      format.html
      format.xml  { render :xml => @recipient }
    end
  end
  
  def fancybox_show
    @recipient = Recipient.find(params[:id])
    @recipient.update_attributes(:is_read => true)

    respond_to do |format|
      format.html { render :layout => false }
      format.xml  { render :xml => @recipient }
    end
  end

  # GET /recipients/new
  # GET /recipients/new.xml
  def new
    @recipient = Recipient.new

    respond_to do |format|
      format.html # new.html.haml
      format.xml  { render :xml => @recipient }
    end
  end

  # GET /recipients/1/edit
  def edit
    @recipient = Recipient.find(params[:id])
  end

  # POST /recipients
  # POST /recipients.xml
  def create
    @recipient = Recipient.new(params[:recipient])
    respond_to do |format|
      if @recipient.save
        if @recipient.user.email_messages == true
          SystemMessageMailer.new_message_email(@recipient).deliver
        end
        format.html { redirect_to(@recipient, :notice => 'Recipient was successfully created.') }
        format.xml  { render :xml => @recipient, :status => :created, :location => @recipient }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @recipient.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /recipients/1
  # PUT /recipients/1.xml
  def update
    @recipient = Recipient.find(params[:id])

    respond_to do |format|
      if @recipient.update_attributes(params[:recipient])
        format.html { redirect_to(@recipient, :notice => 'Recipient was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @recipient.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /recipients/1
  # DELETE /recipients/1.xml
  def destroy
    @recipient = Recipient.find(params[:id])
    @recipient.update_attribute(:is_deleted, true)

    respond_to do |format|
      format.html { redirect_to after_sign_in_path_for(current_user),  :notice => 'Note successfully deleted.'
 }
      format.xml  { head :ok }
    end
  end
  
  
  def mark_as
    if params[:commit] == "Mark as read"
      Recipient.update_all({:is_read => true}, :id => params[:recipient_ids])
    elsif params[:commit] == "Mark as unread"
      Recipient.update_all({:is_read => false}, :id => params[:recipient_ids])
    elsif params[:commit] == "Delete"
      Recipient.update_all({:is_read => true, :is_deleted => true}, :id => params[:recipient_ids])
    end
    redirect_to :back
  end

end
