class Location < ActiveRecord::Base

  attr_writer :organization_name
  attr_accessor :is_headquarters
  belongs_to :address, :dependent => :destroy
  accepts_nested_attributes_for :address
  #validates_associated :address
  belongs_to :contact_method, :foreign_key => :phone_id, :dependent => :destroy
  accepts_nested_attributes_for :contact_method
  belongs_to :organization
  has_many :roles, :through => :organization
  has_many :inventory_items, :through => :inventory_item_locations
  has_many :inventory_item_locations, :dependent => :destroy
  belongs_to :primary_contact, :class_name => 'User', :foreign_key => :primary_contact_id

  default_scope order('name ASC')
  before_save :geocode_it!
  ##COmmented out while converting allow system for orgs
  #before_update :credit_limit
  before_validation(:on => :create) do
    if self.is_headquarters == true
      self.name =  "Corporate Offices"
    elsif !self.address.city.blank?
      self.name = self.address.city
    end
  end

  #validates :name, :presence => true

  searchable do

##    # Advanced Search
##    text :organization_name, :boost => 2.0, :as => :name_textsubstring do
##      organization.name if is_active
##    end
##    text :categories, :as => :categories_textsubstring do
##      organization.categories.map { |category| category.name } if is_active
##    end
##    text :location_name, :as => :locations_textsubstring do
##      name if is_active
##    end
##    text :address_line1, :as => :address_line1_textsubstring do
##      address.line_1 if is_active
##    end
##    text :address_line2, :as => :address_line2_textsubstring do
##      address.line_2 if is_active
##    end
##    text :address_city, :as => :address_city_textsubstring do
##      address.city if is_active
##    end
##    text :address_state, :as => :address_state_textsubstring do
##      address.region if is_active
##    end
##    text :address_zipcode, :as => :address_zipcode_textsubstring do
##      address.postal_code if is_active
##    end
##    text :address_country, :as => 'address_country_textsubstring' do
##      address.country if is_active
##    end

    # Filtered search
    
    # Index the name as a normal text fields. Exact name matches boosted a bit.
    text :organization_name, :boost => 3.0 do
      organization.name
    end

    # Index the name again with ngrams for partial name matches.
    text :organization_name_substring, :as => 'organization_name_textsubstring', :boost => 2.0 do
      organization.name
    end
    
    text :categories, :as => 'categories_textsubstring', :boost => 1.8  do
      organization.categories.map { |category| category.name }
    end

    integer :category_ids, :multiple => true do
      organization.categories.map { |category| category.id }
    end

    text :location_name, :as => 'locations_textsubstring' do
      name
    end

    text :address_line1, :as => 'address_line1_textsubstring' do
      address.line_1
    end

    text :address_line2, :as => 'address_line2_textsubstring' do
      address.line_2
    end

    text :address_city, :as => 'address_city_textsubstring', :boost => 1.6 do
      address.city
    end

    text :address_state, :boost => 3.0 do
      address.region
    end

    # for indexing city, region
    string :city_region do
      address.city.to_s + ', ' + address.region.to_s
    end

    text :address_zipcode, :as => 'address_zipcode_textsubstring', :boost => 1.7 do
      address.postal_code
    end

    text :address_country, :as => 'address_country_textsubstring' do
      address.country
    end

    text :primary_contact_name, :as => 'primary_contact_name_textsubstring', :boost => 1.4 do
      primary_contact.name rescue ""
    end

    # for indexing full country name
    string :country do
      address.country.to_s
    end

    boolean :is_active do
      is_active
    end

    boolean :is_featured  do
      organization.is_featured
    end
    
##    # can't make this work
##    string :tags, :multiple => true do
##      list = []
##      organization.categories.map do |category|
##        list << category.tag_list
##      end
##      list.flatten.uniq
##    end

    text :category_tags, :as => 'category_tags_textsubstring', :boost => 1.9  do
      organization.categories.map { |c| c.tag_list.compact }.flatten.join(' , ')
    end

    #using ngrams on keywords prevents a single word from indexing
    #text :keywords, :as => 'keywords_textsubstring' do
    text :keywords do
      if organization.account_type and organization.account_type.allow_keywords?
        organization.keywords
      end
    end

#    boolean :is_approved do
#      organization.is_approved
#    end

    float :rating

    #boost { organization.free_subscription? ? 10.0 : 1.0 }
    # boost do
    #   if organization.free_subscription?
    #     1.0
    #   else
    #     10.0
    #   end
    # end


    # string :title, :stored => true
    # integer :blog_id, :references => Blog
    # integer :category_ids, :references => Category, :multiple => true
    # float :average_rating
    # time :published_at
    # boolean :featured, :using => :featured?
    # boost { featured? ? 2.0 : 1.0 }

    boolean :is_student_friendly do
      organization.is_student_friendly
    end

    boolean :is_motorcoach_friendly do
      organization.is_motorcoach_friendly
    end
  end
  
  # Returns an array of phrases generated from the organization name.
  # Similar to letter-based NGram generation.
  # Use these phrases for Solr spellcheck and query autosuggest.
  def organization_name_phrases
    terms = organization.name.gsub(/\s\W*\s+/, ' ').gsub(/\b[^a-zA-Z0-9 ]\b/, '').split(/\s/)
    max_phrase_size = terms.length
    (2..max_phrase_size).collect do |size|
      (0..(terms.length - size)).collect do |i|
        terms[i, size].join(" ")
      end
    end.flatten
  end
  
  def self.from_featured_organizations
    Location.send(:with_exclusive_scope) do
      order('RANDOM()').
        joins(:organization).
        where(:organizations => {:is_featured => true}, :is_active => true)
    end
  end

  def map_address
    a = [self.address.line_1, self.address.city, self.address.region, self.address.postal_code]
    a.compact.join(", ").tap { |_address| logger.info("Geocoding: #{_address}") }
  end

  def credit_limit
    inventory_items_ids = self.organization.inventory_items.collect(&:id)

    credits_used = self.organization.credits_used
    credit_limit = self.organization.credit_limit
    credit_limit = 0 unless credit_limit.is_a? Fixnum
    if new_record?
      return true if (inventory_item_ids.select{|x| !x.blank?}.size + credits_used) <= credit_limit
      left_credits = credit_limit - credits_used
      extra_credits = (inventory_item_ids.select{|x| !x.blank?}.size + credits_used) - credit_limit
    else
      return true if credits_used <= credit_limit
      left_credits = (credit_limit - credits_used)
      extra_credits = left_credits < 0 ? left_credits * -1 : left_credits
      left_credits = 0
    end
    errors.add(:base, "You only have #{left_credits} credits left. Please deselect #{extra_credits} Inventory items and try again.")

    false
  end

  def geocode_it!
    _location = Geokit::Geocoders::MultiGeocoder.geocode(map_address)
    if _location.lat && _location.lng && _location.accuracy
      self.address.lat = _location.lat
      self.address.lng = _location.lng
      self.address.accuracy = _location.accuracy
    else
      self.address.accuracy = -1
    end

    self.address.save
    true
  end

  # if map accurace > 0
  def map_available?
    self.addresses.accuracy > 0
  end

  def map_address
    _address = self.address.line_1
    _address += ', ' + self.address.city if self.address.city.present?
    _address += ', ' + self.address.region if self.address.region.present?
    _address += ', ' + self.address.postal_code if self.address.postal_code.present?
    _address
  end

  def lat
    self.address.lat
  end

  def lng
    self.address.lng
  end

  def accuracy
    self.address.accuracy
  end

  def organization_type
    categoryobj=Categorization.find_by_organization_id(self.organization_id)
    categoryobj.category.marker_colors
  end

  def rating
    !organization.free_subscription? ? 10.0 : 1.0
  end

  def headquarters?
    self.name == "Corporate Offices"
  end

  def self.geocode(address_text)
    Geokit::Geocoders::MultiGeocoder.geocode(address_text)
  end
end