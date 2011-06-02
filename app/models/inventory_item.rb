class InventoryItem < ActiveRecord::Base
  belongs_to :organization
  has_many :roles, :through => :organization
  has_many :inventory_item_locations, :dependent => :destroy
  has_many :locations, :through => :inventory_item_locations, :uniq => true
  has_one :price, :as => :priceable
  accepts_nested_attributes_for :price
  accepts_nested_attributes_for :inventory_item_locations, :reject_if => proc {|a| a['location_id'].blank?}, :allow_destroy => true


    #accepts_nested_attributes_for :locations

  #accepts_nested_attributes_for :locations
  #default_scope order('name ASC')

  #before_save :credit_limit

  before_update :credit_limit

  validates :name, :presence => true
  validates :description, :presence => true
  
  #attr_accessor :price, :retail


  def credit_limit
    
    credits_used = self.organization.inventory_item_locations.size
    Rails.logger.debug "START **********************************************************************"
    Rails.logger.debug ""
    Rails.logger.debug "credits_used"
    Rails.logger.debug credits_used
    Rails.logger.debug ""
    Rails.logger.debug "END  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^"

    credit_limit = self.organization.account_type.credits   
    Rails.logger.debug "START **********************************************************************"
    Rails.logger.debug ""
    Rails.logger.debug "credit_limit"
    Rails.logger.debug credit_limit
    Rails.logger.debug ""
    Rails.logger.debug "END  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^"
    
    
    
    locations_ids = self.organization.locations.collect(&:id)

    #credits_used = self.organization.credits_used
    #credit_limit = self.organization.credit_limit
    #credit_limit = 0 unless credit_limit.is_a? Fixnum
    if new_record?
      return true if credit_limit.nil?
      return true if (location_ids.select{|x| !x.blank?}.size + credits_used) <= credit_limit
      left_credits = credit_limit - credits_used
      extra_credits = (location_ids.select{|x| !x.blank?}.size + credits_used) - credit_limit
    else
      return true if credit_limit.nil?
      return true if credits_used <= credit_limit
      left_credits = (credit_limit - credits_used)
      extra_credits = left_credits < 0 ? left_credits * -1 : left_credits
      left_credits = 0
    end
    if left_credits > 1
      errors.add(:base, "You only have #{left_credits} credits left. Please deselect #{extra_credits} Locations and try again.")
    elsif left_credits == 1
      errors.add(:base, "You only have one credit left. Please deselect #{extra_credits} Locations and try again.")
    elsif left_credits == 0
      errors.add(:base, "You do not have any credits left. Please deselect #{extra_credits} Locations and try again.")
    end
    false
  end
end