class Address < ActiveRecord::Base
  has_one :location
  default_scope order('updated_at DESC')
  validates :line_1, :presence => true
  validates :city, :presence => true
  validates :region, :presence => true, :unless => :no_region_needed
  validates :country, :presence => true
  validates :postal_code, :postal_code_format => true
  
  attr_accessor :us_region, :us_postal_code, :ca_region, :ca_postal_code, :other_region, :other_postal_code, :t_line_1, :t_line_2, :t_city
    
  def no_region_needed
    if country != "United States"
      true
    end
  end
end
