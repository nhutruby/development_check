class Recipient < ActiveRecord::Base
  belongs_to :note
  belongs_to :user
  belongs_to :role
 default_scope order('recipients.created_at DESC')
  scope :inbox, lambda {
    where("is_deleted IS false AND notes.is_sysmessage IS false", includes(:notes))
  }
  scope :notifications, lambda {
    where("is_deleted IS false AND notes.is_sysmessage IS true", includes(:notes))
  }
  
  scope :active, lambda {
    where("is_deleted IS false", includes(:notes))
  }
end