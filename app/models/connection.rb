class Connection < ActiveRecord::Base
  belongs_to :user
  belongs_to :connectionship, :class_name => "User", :foreign_key => :connection_id
  has_one :inverse_connection, :class_name => "Connection", :primary_key => :user_id, :foreign_key => :connection_id
  
  #default_scope :include => [:user, :connectionship] , :order => 'connectionships_connections.name_last ASC, connectionships_connections.name_first ASC'
  
  scope :requested, :conditions => {:is_approved => nil}
  scope :approved, :conditions => {:is_approved => true}

  after_save :create_inverse_connection


  def create_inverse_connection
    if self.is_approved == true and !self.inverse_connection
      user_id = self.connection_id
      connection_id = self.user_id
      Connection.create(:user_id => user_id, :connection_id => connection_id, :is_approved => true)
    end
  end

end

