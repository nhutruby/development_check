class Category < ActiveRecord::Base

  # Setup Relations
  has_many :categorizations, :autosave => true, :inverse_of => :category
  has_many :organizations, :through => :categorizations, :autosave => true
  
  default_scope :order => ["position", "tipe", "name"]
  scope :supplier, where("tipe = supplier")  
  validates :name, :presence => true

  def tag_list
    return [] if self.tags.nil?
    
    self.tags.split(',').map { |tag| tag.strip }.compact
  end

end