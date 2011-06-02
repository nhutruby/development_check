class Note < ActiveRecord::Base
  has_many :users, :through => :recipient
  has_many :recipients
  belongs_to :sender, :class_name => 'User', :foreign_key => :sender_id
  accepts_nested_attributes_for :recipients
  
  default_scope order('updated_at DESC')
  
  scope :unread, :conditions => {:is_read => false}
  scope :not_deleted, :joins => :recipients, :conditions => "recipients.is_deleted IS FALSE"
  
  before_save :set_occurred_at
  
  
  def set_occurred_at
    self.occurred_at = Time.now
  end
  
 
end
