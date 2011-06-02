class Membership < ActiveRecord::Base
  belongs_to :organization, :class_name => "Organization", :foreign_key => :organization_id
  belongs_to :member, :class_name => "Organization", :foreign_key => :member_id
  
  # Callbacks
  after_save :update_member_count, :except => :destroy
  
  scope :approved, where(:is_organization_approved => true)

  
  def update_member_count
    org = self.organization
    
    count = org.memberships.approved.count if org.memberships.approved.count
    org.update_attribute(:member_count, count) if org.memberships.approved.count
  end

end