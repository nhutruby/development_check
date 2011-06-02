class Role < ActiveRecord::Base
  # Setup Relations
  has_many :team_members, :class_name => "Role", :primary_key => :organization_id, :foreign_key => :organization_id
  #belongs_to :team_leader, :class_name => "Role", :primary_key => :organization_id, :foreign_key => :organization_id
  belongs_to :user, :autosave => true
  belongs_to :organization, :autosave => true
  has_one :recipient, :dependent => :destroy
  accepts_nested_attributes_for :user
  accepts_nested_attributes_for :organization

  scope :ordered, :joins => :user, :order => 'users.name_last ASC, users.name_first ASC'
  scope :approved, lambda {where("roles.is_user_approved IS TRUE AND roles.is_organization_approved IS TRUE")}  
  scope :not_org_approved, lambda {where("roles.is_user_approved IS TRUE AND roles.is_organization_approved IS NULL")}  
  scope :not_user_approved, lambda {where("roles.is_user_approved IS NULL AND roles.is_organization_approved IS TRUE")}
  
  validates_uniqueness_of :user_id, :scope => :organization_id, :message => "can only have one role with an organization"
  
    
#  private
  
#  def establish_relationships
#    if self.role
#    else
#      self.roles.create
end