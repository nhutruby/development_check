class Rating < ActiveRecord::Base
  belongs_to :entity, :polymorphic => true
  scope :closed, :conditions => {:is_closed => "true"}
end