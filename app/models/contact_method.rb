class ContactMethod < ActiveRecord::Base
  has_one :location, :foreign_key => :phone_id
  belongs_to :entity, :polymorphic => true
  
  
  default_scope order('updated_at DESC')
  include ActionView::Helpers::NumberHelper
  before_validation :format_address
  
  validates :address, :contact_method => true
  validates :name, :presence => true
  
  scope :phone, :conditions => {:name => "phone"}
  scope :email, :conditions => {:name =>  "email"}
  scope :website, :conditions => {:name =>  "website"}
  scope :tweets, :conditions => {:name =>  "Twitter"}
  
  def format_address    
#    number = self.address.gsub!(/[-.() ]/, "").to_i
    if self.name == "phone"
      unless self.address.empty?
        number = self.address.gsub(/[^0-9]/, "")
        self.address = number_to_phone(number, :area_code => true)
      end
    end
  end

end
  
 
