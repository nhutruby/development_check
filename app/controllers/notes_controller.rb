class NotesController < ApplicationController
  #Devise Authentication
  before_filter :authenticate_user!
    
  
  
  #CanCan Authorization
  load_and_authorize_resource
  
  # GET /notes
  # GET /notes.xml
  def index
    @notes = Note.all

    respond_to do |format|
      format.html # index.html.haml
      format.xml  { render :xml => @notes }
    end
  end

  # GET /notes/1
  # GET /notes/1.xml
  def show
    @note = Note.find(params[:id])

    respond_to do |format|
      format.html # show.html.haml
      format.xml  { render :xml => @note }
    end
  end

  # GET /notes/new
  # GET /notes/new.xml
  def new
    @note = Note.new(:sender_id => params[:sender_id], :subject => params[:subject], :body => params[:body] )
    @recipient = @note.recipients.build(:user_id => params[:recipient_id])

    respond_to do |format|
      format.html # new.html.haml
      format.xml  { render :xml => @note }
    end
  end

  # GET /notes/1/edit
  def edit
    @note = Note.find(params[:id])
  end

  # POST /notes
  # POST /notes.xml
  def create
    @note = Note.new(params[:note])
    @note.occurred_at = Time.now

    respond_to do |format|
      if @note.save
        for recipient in @note.recipients
          if recipient.user.email_messages == true
            #send late using delayed_job
            SystemMessageMailer.delay.new_message_email(recipient)
            #without delayed_job...
            #SystemMessageMailer.new_message_email(recipient).send_later(:deliver)
          end
        end
        format.html { redirect_to(dashboard_path, :notice => 'Your message has been sent.') }
        format.xml  { render :xml => @note, :status => :created, :location => @note }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @note.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /notes/1
  # PUT /notes/1.xml
  def update
    @note = Note.find(params[:id])

    respond_to do |format|
      if @note.update_attributes(params[:note])
        format.html { redirect_to(@note, :notice => 'Note was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @note.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /notes/1
  # DELETE /notes/1.xml
  def destroy
    @note = Note.find(params[:id])
    @note.destroy

    respond_to do |format|
      format.html { redirect_to(notes_url) }
      format.xml  { head :ok }
    end
  end
  
end
