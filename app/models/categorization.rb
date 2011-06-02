class Categorization < ActiveRecord::Base
  
  # Setup Relations
  belongs_to :organization
  belongs_to :category, :inverse_of => :categorizations
  
  accepts_nested_attributes_for :category, :organization
  

end
