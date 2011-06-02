require 'csv'
require 'open-uri'
class ConnectionsController < ApplicationController
  #Devise Authentication
  before_filter :authenticate_user!
    
  #include ActionDispatch
  
  load_and_authorize_resource

  def index
    @connections = Connection.paginate(:conditions => {:user_id => current_user.id, :is_approved => true}, :page => params[:page], :per_page => 10, :include => [:connectionship], :order => "users.name_last, users.name_first")
  end

  def inner_circle
    @connections = current_user.connections.paginate(:conditions => ['is_inner_circle IS true'], :page => params[:page], :per_page => 10, :include => [:connectionship], :order => "users.name_last, users.name_first")
  end

  def requested
    @connections = current_user.inverse_connections.paginate(:conditions => ['is_approved = false or is_approved IS NULL'], :page => params[:page], :per_page => 10, :include => [:connectionship], :order => "users.name_last, users.name_first")
  end

  def create
    @connection = current_user.connections.build(:connection_id => params[:connection_id])

    respond_to do |format|
      if @connection.save
        format.html { redirect_to(request.env["HTTP_REFERER"], :notice => 'Your connection request has been sent.')}
        format.xml  { render :xml => @connection, :status => :created, :location => @connection }
      else
        format.html { redirect_to(request.env["HTTP_REFERER"], :notice => 'Your connection request could not be sent at this time.') }
        format.xml  { render :xml => @connection.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update
    @connection = Connection.find(params[:id])
    if params[:is_inner_circle]
      @connection.is_inner_circle = params[:is_inner_circle]
    end
    if params[:is_approved]
      @connection.is_approved = params[:is_approved]
    end
    respond_to do |format|
      if @connection.update_attributes(params[:connection])
        format.html { redirect_to(request.env["HTTP_REFERER"])}
      end
    end
  end

  def destroy
    @connection = Connection.find(params[:id])
    @inverse = @connection.inverse_connection
    if @inverse
      @inverse.destroy
    end
    if @connection
      @connection.destroy
    end

    respond_to do |format|
      format.html { redirect_to(request.env["HTTP_REFERER"]) }
      format.xml  { head :ok }
    end
  end

  def find_connections

    @user = current_user
    if request.post?
      @list_connections = []
      @domains = {"gmail" => Contacts::Gmail,
        "yahoo" => Contacts::Yahoo,
        "hotmail" => Contacts::Hotmail,
        "aol" => Contacts::Aol
      }

      if (params[:mail_type] == "aol" || params[:mail_type] == "hotmail") && !params[:email].blank?
        unless params[:email].split("@").size > 1
          params[:email] = params[:email].to_s + "@" + params[:mail_type].to_s + ".com"
        end
      end
      unless params[:mail_type] == "other"
        begin
          @contacts = @domains[params[:mail_type]].new(params[:email], params[:password]).contacts
        rescue Contacts::AuthenticationError => e
          @error = e
        rescue Contacts::ConnectionError => c
          @error = c
          ErrorNotification.error_email(c).deliver
        end
      else
        @contacts = []
        if params[:file]
          buffer = open(params[:file].tempfile.path, "UserAgent" => "Ruby-CSVReader").read unless RUBY_VERSION < '1.9'
          @csv = (RUBY_VERSION < '1.9' ? CSV::Reader.parse(params[:file]) : CSV.parse(buffer))
          @csv = @csv.map{|c| c.compact.map{|a| a.match( /(^([^@\s]+)@((?:[-_a-z0-9]+\.)+[a-z]{2,})$)|(^$)/i)}.compact}.flatten.compact.map{|c| c[0]}
          @csv.each_with_index{|row, index|
            @contacts << [index, row]
          }
        else
          @error = "Please check your uploaded csv file."
        end
      end

      @contacts = @contacts.map{|c| c[1].split(Regexp.escape("&amp;"))[0]}.uniq if @contacts
      @contacts.each do|contact|
        @existed_user = User.find_by_email( contact, :conditions => ["confirmed_at IS NOT NULL"]) unless current_user.email == contact
        if (current_user.email != contact && @existed_user)
          @connectionships = Connection.find(:first, :conditions => ["user_id =? and connection_id=?", current_user.id, @existed_user.id])
          @list_connections << @existed_user unless @connectionships
        end
      end if @contacts
      @list_connections = @list_connections.flatten.compact
      render :action => :list_connections
    end

  end

  def list_connections
    @user = current_user
  end

  def update_conection
    @contacts = params[:contacts]
    @contacts.each do |connection|
      Connection.find_or_create_by_user_id_and_connection_id(current_user.id, connection)
    end if @contacts
    flash[:notice] = "Connections request Successfully Sent."
    redirect_to find_connections_connections_path
  end
end
