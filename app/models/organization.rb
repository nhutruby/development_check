class Organization < ActiveRecord::Base
  require 'iconv'
  include ActionView::Helpers::UrlHelper
  include Rails.application.routes.url_helpers

  searchable do
    text :name, :as => :org_name_textsubstring

    string :name
    string :first_letter, :stored => true do
      name.capitalize.first
    end
    integer :association_ids, :multiple => true
    boolean :is_student_friendly
    boolean :is_motorcoach_friendly
    # string :title, :stored => true
    # integer :blog_id, :references => Blog
    # integer :category_ids, :references => Category, :multiple => true
    # float :average_rating
    # time :published_at
    # boolean :featured, :using => :featured?
    # boost { featured? ? 2.0 : 1.0 }
  end

  validates :name, :presence => true
  #validates :description, :description => true
  validates :locations, :presence => true, :associated => true
  #validates :categorizations, :presence => true, :associated => true
  validate :require_at_least_one_category
  validates_associated :assets
  validates_associated :locations

  #validate do |org|
    #org.errors.add(:base, "At least one Product or Service must be selected") if org.categories.empty?
  #end

  #TODO - Temporarily commented out on 3/30 because it would not allow user to claim organization - PC
  #validate :valid_subscription
  
  
  # validates_presence_of :billing_first_name
  # validates_presence_of :billing_last_name
  # validates_presence_of :billing_email
  # validates_format_of :billing_email, :with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i, :message => "format is invalid."
  extend ActiveSupport::Memoizable

  after_update :reprocess_logo, :if => :cropping?
  after_create :create_role
  before_validation :clear_logo
  before_save :check_complete
  before_save :transliterate_twitter_name
  after_save :trial_message
  after_commit :check_users_and_credits
  before_save :account_typing
  #after_destroy :cancel_subscription
  #after_create :create_chargify_subscription
  after_update :update_locations_index
  after_destroy :cancel_chargify_subscription, :remove_locations_index
  #after_save :sync_chargify_customer

  attr_accessor :crop_x, :crop_y, :crop_w, :crop_h, :delete_logo, :assn_id, :claim #, :new_org_id
  attr_accessor :credit_card
  attr_accessor :object, :title
  attr_reader :dmo_tokens
  
  def dmo_tokens=(ids)
    dmo_ids = ids.split(",").to_a
    Rails.logger.debug "START **********************************************************************"
    Rails.logger.debug ""
    Rails.logger.debug "dmo_ids"
    Rails.logger.debug dmo_ids
    Rails.logger.debug ""
    Rails.logger.debug "END  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^"
    Rails.logger.debug "START **********************************************************************"
    Rails.logger.debug ""
    Rails.logger.debug "self.association_ids"
    Rails.logger.debug self.association_ids
    Rails.logger.debug ""
    Rails.logger.debug "END  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^"
    self.association_ids = self.association_ids + dmo_ids
    Rails.logger.debug "START **********************************************************************"
    Rails.logger.debug ""
    Rails.logger.debug "self.association_ids"
    Rails.logger.debug self.association_ids
    Rails.logger.debug ""
    Rails.logger.debug "END  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^"
  end


  default_scope order('Organizations.name ASC')

  scope :with_logos, order('logo_file_name IS NULL ASC, name ASC')
  scope :trade_associations, :include => :categories, :conditions => "categories.name='Trade Association'"
  scope :dmas, :select => ["organizations.id, organizations.name"], :joins => :categories, :conditions => "categories.name='Destination Marketing Association'"


  # Setup Relations
  has_many :assets, :as => :assetable, :dependent => :destroy
  accepts_nested_attributes_for :assets, :reject_if => proc {|a| a['file'].blank? && a['name'].blank? && a['description'].blank? && a['delete_file'] != "1"}, :allow_destroy => true
  belongs_to :account_type
  has_many :roles, :dependent => :destroy
  has_many :team_members, :through => :roles, :foreign_key => :user_id, :source => :user
  has_many :categorizations, :autosave => true, :dependent => :destroy
  accepts_nested_attributes_for :categorizations, :reject_if => :all_blank
  has_many :categories, :through => :categorizations, :autosave => true
  accepts_nested_attributes_for :categories
  has_many :locations, :autosave => true, :dependent => :destroy
  accepts_nested_attributes_for :locations
  has_many :addresses, :through => :locations, :autosave => true, :dependent => :destroy
  accepts_nested_attributes_for :addresses
  has_many :inventory_items
  has_many :inventory_item_locations, :through => :inventory_items
  accepts_nested_attributes_for :roles
  has_many :users, :through => :roles
  belongs_to :primary_contact, :class_name => 'User', :foreign_key => :primary_contact_id
  belongs_to :owner, :class_name => 'User', :foreign_key => :owner_id
  accepts_nested_attributes_for :users

  has_many :memberships, :dependent => :destroy
  has_many :members, :through => :memberships
  has_many :association_memberships, :class_name => "Membership", :foreign_key => :member_id, :dependent => :destroy
  has_many :associations, :through => :association_memberships, :source => :organization
  has_many :ratings, :as => :entity, :dependent => :destroy
  
  accepts_nested_attributes_for :ratings

  
  profanity_filter :description, :long_description, :method => 'dictionary'

  #Paperclip Gem
  validates_attachment_content_type :logo, :content_type => ['image/jpeg', 'image/png', 'image/gif', "image/pjpeg", "image/x-png", "image/x-citrix-pjpeg", "image/x-citrix-gif"], :message => "should be \"PNG, GIF, or JPG\""
  validates_attachment_size :logo, :less_than => 2.megabytes, :message => "must be less than 2MB"
  has_attached_file :logo,
    :styles => {
        :large => "500x500>",
        :medium => "300x300>",
        :thumb => "55x55>",
        :mini => "30x30>"
    },
    :processors => [:cropper],
    :storage => :s3,
    :s3_credentials => "#{::Rails.root.to_s}/config/s3.yml",
    :path => ":attachment/:id/:style/:basename.:extension",
    :bucket => "itoursmart-#{Rails.env}"
  before_post_process :allow_only_images
  before_post_process :transliterate_file_name

  #has_attached_file :banner,
    #:styles => {
        #:large => "234x60>",
    #},
    #:storage => :s3,
    #:s3_credentials => "#{::Rails.root.to_s}/config/s3.yml",
    #:path => ":banner/:id/:style/:basename.:extension",
    #:bucket => "itoursmart-#{Rails.env}"
  #before_post_process :transliterate_file_name

  #validates_attachment_presence :logo
  #validates_attachment_content_type :logo, :content_type => ['image/gif', 'image/png'] unless :file

  # Returns an array of phrases generated from the organization name.
  # Similar to letter-based NGram generation.
  # Use these phrases for Solr spellcheck and query autosuggest.
  def name_phrases
    terms = name.gsub(/\s\W*\s+/, ' ').gsub(/\b[^a-zA-Z0-9 ]\b/, '').split(/\s/)
    max_phrase_size = terms.length
    (2..max_phrase_size).collect do |size|
      (0..(terms.length - size)).collect do |i|
        terms[i, size].join(" ")
      end
    end.flatten
  end
  
  def self.featured
    where(:is_featured => true)
  end

  def association_ids
    Membership.where(:member_id => self.id).collect(&:organization_id)
  end

  def create_role
    self.roles.create(:user_id => self.creator_id, :is_admin => true, :is_user_approved => true, :is_organization_approved => true) if self.creator_id
    #self.update_attribute(:primary_contact_id, self.creator_id)
  end

  def cropping?
    !crop_x.blank? && !crop_y.blank? && !crop_w.blank? && !crop_h.blank?
  end

  def logo_geometry(style = :original)
    @geometry ||= {}
    @geometry[style] ||= Paperclip::Geometry.from_file(logo.url(style))
  end

  def self.search(search)
    if search
      @organizations = find(:all, :conditions => ['name ILIKE ?', "%#{search}%" ])
    else
      @organizations = find.all
    end

  end

  def logo_url(size = ":mini")
    # if self.logo.exists? && !self.free_subscription? && (self.subscription_state.to_s.eql?("active") or Time.now < self.try(:trial_ends_at))
    if self.logo.exists?
      return self.logo.url(size)
    end
    ""
  end

  def clear_logo
    self.logo = nil if self.delete_logo=="1" && !self.logo.dirty?
  end

  def credits_used
    #PC changed CB code on 4/14/2011 at 5:00 PM  Old Code:
    #inv_items_ids = self.inventory_items.collect(&:id)
    #loc_ids = self.locations.collect(&:id)
    #InventoryItemLocation.where(["location_id IN (?) AND inventory_item_id IN (?)", loc_ids, inv_items_ids]).size
    
    #New Code
    self.inventory_item_locations.size
  end

  def credit_limit
    self.account_type.credits if self.account_type
      
    #if self.free_subscription?
      #free = YAML.load_file "#{RAILS_ROOT}/config/free_subscription_credits.yml"
      #return free['credits'].to_i
      # a_config = YAML.load_file "#{RAILS_ROOT}/config/application.yml"
      # a_config["user"]["pwd_days"] = params[:days]
      # File.open("#{RAILS_ROOT}/config/application.yml", 'w') { |f| YAML.dump(a_config, f) }
    #else
      #account_type = AccountType.find_by_product_id(self.subscription.product.id)
      #return (account_type.nil? ? "N/A" : account_type.credits)
    #end
  end
  
  def can_add_team_member?
    if self.account_type.user_limit.nil?
      true
    elsif self.account_type.user_limit > self.roles.count
      true
    else
      false
    end
  end

  def trial?
    return false if self.trial_started_at.blank?
    return false if self.trial_ends_at.blank?
    return Time.now <= self.trial_ends_at
  end

  def trial_subscription?
    self.free_subscription? && self.trial?
  end
  
  def free_subscription?
    if self.account_type && self.account_type.link_to_chargify?
      false
    else
      true
    end

    #if self.master_type == "association" || self.master_type == "dmo"  || self.master_type == "provider"
      #false
    #else
      #self.selected_plan.to_s.eql?(Subscription::FREE_PLAN_HANDLE)
      #legacy method that query Chargify API
      #_subscription = self.subscription
      #_subscription.reload if _subscription.is_a?(Chargify::Subscription)
      #_subscription.product.handle.eql?(Subscription::FREE_PLAN_HANDLE)
    #end
  end

  #def paid_subscription?
    #return true if self.master_type == "association"
    #return true if self.master_type == "dmo"
    #return true if self.master_type == "provider"
    #return true if !self.free_subscription? && self.subscription_state.to_s.eql?("active")
    #return true if self.trial_subscription?
    #false
  #end

  def subscription
    #create _subscription variable and set to nil
    _subscription = nil
    begin
      #set _subscription to the related subscription from chargify
      _subscription = Chargify::Subscription.find(subscription_id)
    rescue
      _subscription = Subscription.new
    end
    _subscription
  end

  def customer
    _customer = nil
    begin
      _customer = Chargify::Customer.find(customer_id)
    rescue
      begin
        _customer = Chargify::Customer.find_by_reference(owner_id)
      rescue
        _customer = nil
      end
    end
    _customer
  end

  memoize :subscription, :customer

  # def chargify_to_premium!
  #   subscription = find_or_create_chargify_customer(id)
  #   subscription.migrate(:product_handle => 'premium_handle', :include_initial_charge => true) if subscription.product.handle != 'premium_handle'
  #   if subscription.reload.state == 'active'
  #     #NotificationsMailer.deliver_user_upgraded(self)
  #   end
  # rescue
  #   false
  # end
  #
  # def chargify_to_free!
  #   subscription = find_or_create_chargify_customer(id)
  #   if subscription.product.handle != 'free_plan'
  #     if subscription.migrate(:product_handle => 'free_plan')
  #       #NotificationsMailer.deliver_user_downgraded(self)
  #     end
  #   else
  #     true
  #   end
  # end

  def migrate_subscription(product_id)
    current_subscription = subscription
    Rails.logger.debug "^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^"
    Rails.logger.debug subscription.inspect
    if current_subscription.product.id != product_id
      if !AccountType.find_by_product_id(product_id).link_to_chargify?
        cancel_chargify_subscription
        self.subscription_id = nil
        return self.save
      else
        begin
          current_subscription.migrate(:product_id => product_id, :include_initial_charge => true)
          current_subscription = current_subscription.reload
          if current_subscription.state == 'active'
            #NotificationsMailer.deliver_user_upgraded(self)
            #NotificationsMailer.deliver_user_downgraded(self)
          #else
            #self.update_attributes({ :subscription_state => current_subscription.state })
          end
          if Rails.env != 'production'	
              self.selected_plan = current_subscription.product.handle	
          end
          return self.save
        rescue
          errors.add(:base, "The subscription could not be processed. Please verify that your credit card information is correct.")
        end
      end
    else
      errors.add(:base, "You can not subscribe to the same product twice.")
    end
    false
  end

  # def create_and_subscribe
  #   success = true
  #   return unless self.valid?
  #   Organization.transaction do
  #     self.save
  #     unless create_chargify_subscription
  #       success = false
  #       raise ActiveRecord::Rollback
  #     end
  #   end
  #   success
  # end
  
  def entity
    if name.include? "Organization" or name.include? "Association" or name.include? "Bureau" or categories.any? {|c| c.tipe == "association" or c.tipe == "dmo"}
      "Organization"
    else
      "Company"
    end
  end
    
  def check_complete
    self.is_complete = true
  end

  def keywords_list
    return [] if self.keywords.nil?
    self.keywords.split(',').collect { |v| v.strip }
  end
 
  def check_users_and_credits
    if self.owner_id
      if self.account_type and self.account_type.credits.nil?
        #do nothing for now
      elsif self.account_type and self.account_type.credits < self.inventory_item_locations.count
        self.inventory_item_locations.each {|l| l.destroy}
      end
      if self.account_type and self.account_type.user_limit.nil?
      elsif self.account_type and self.account_type.user_limit < self.roles.count
        self.roles.where("roles.user_id <> ?", self.owner_id).each {|r| r.destroy}
      end
    end
  end

  def update_chargify_subscription
    unless @already_updated# or [:account_id] or credit_card[:product_id] or !credit_card[:product_id]
      # revert to Courtesy
      if credit_card[:account_type_id].to_i == 7
        cancel_chargify_subscription
      else
        current_subscription = nil
        if self.subscription_id.blank?
          #current_subscription holds the Chargify Subscription object
          current_subscription = Chargify::Subscription.new
        else
          #set to the Chargify Subscription Object if it exists
          current_subscription = subscription
        end
        unless current_subscription.nil?       
          if valid_credit_card?
            product_id = AccountType.find(credit_card[:account_type_id]).product_id
            #where does credit_card[:product_id] come from?
            current_subscription.product_id = product_id#credit_card[:product_id] #if self.free_subscription?
            current_customer = customer
            if current_customer
              if current_customer.reference.to_i == owner_id
                Rails.logger.debug "DEBUG CHARGIFY SUBSCRIPTIONS: owner_id!"
                current_subscription.customer_id = current_customer.id
              else
                Rails.logger.debug "DEBUG CHARGIFY SUBSCRIPTIONS: not an owner_id"
                current_subscription.customer_attributes = customer_attributes
              end
            else
              current_subscription.customer_attributes = customer_attributes
            end
            current_subscription.credit_card_attributes = credit_card_attributes
            #current_subscription.coupon_code = credit_card[:coupon_code]
            unless current_subscription.save
              current_subscription.errors.full_messages.each do |e|
                errors.add(:base, e) unless errors.full_messages.include?(e)
              end
            else
              @already_updated = true
              attrs = {
                :customer_id => current_subscription.customer.id,
                :subscription_id => current_subscription.id,
                :account_type_id => credit_card[:account_type_id]
              }
              if Rails.env != 'production'
                attrs[:selected_plan] = current_subscription.product.handle
                attrs[:subscription_state] = current_subscription.state
              end
              self.update_attributes(attrs)
              @already_updated = false        
           end
          else
            errors.add(:base, "Credit card information is missing or incorrect. Please check and try again.")
          end
        end
      end
    else
      if credit_card[:account_type_id]
        self.update_attributes(:account_type_id => credit_card[:account_type_id])
      elsif [:account_type_id]
        self.update_attributes(:account_type_id => [:account_type_id])
      end
    end
  end

  def cancel_chargify_subscription
    begin
      current_subscription = subscription
      unless self.free_subscription?
        current_subscription.cancellation_message = 'Cancelled via API'
        current_subscription.save
        current_subscription.cancel
        if Rails.env != 'production'
          self.selected_plan = Subscription::FREE_PLAN_HANDLE	
        end
        save
        #NotificationsMailer.deliver_user_canceled(self)
      end
    rescue #ActiveResource::ResourceNotFound
      true
    end
  end

  def as_json(options={})
    super(:only => [:id, :name])
  end  
  
  def transliterate_twitter_name
    unless self.twitter_name.blank?
      twitter_handle = self.twitter_name.gsub(/@/, "")
      self.twitter_name = twitter_handle
    end
  end
  
  private

  def require_at_least_one_category
    errors.add(:base, "You must select at least one business type category") if category_ids.blank?
  end

  def reprocess_logo
    logo.reprocess!
  end

  def valid_subscription
    unless new_record?
      unless credit_card.nil?
        if self.free_subscription?
          errors.add(:base, "You must select a plan to subscribe to.") if credit_card[:product_id].blank?
        end
        errors.add(:base, "Billing first name can't be blank.") if billing_first_name.blank?
        errors.add(:base, "Billing last name can't be blank.") if billing_last_name.blank?
        if billing_email.blank?
          errors.add(:base, "Billing email can't be blank.")
        elsif billing_email.match(/^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i).nil?
          errors.add(:base, "Billing email format is invalid.")
        end
        errors.add(:base, "Credit card number can't be blank.") if credit_card[:credit_card_number].blank?
        errors.add(:base, "Credit card cvv can't be blank.") if credit_card[:cvv].blank?
        errors.add(:base, "Billing ZIP Code can't be blank.") if credit_card[:zip].blank?
      end
    end
  end

  # def create_chargify_subscription
  #   current_subscription = subscription
  #   if current_subscription.nil?
  #     current_subscription = Chargify::Subscription.new(subscription_params(Subscription.free.id))
  #     if current_subscription.save
  #       self.update_attributes({
  #         :customer_id => current_subscription.customer.id,
  #         :subscription_id => current_subscription.id,
  #         :subscription_state => current_subscription.state
  #       })
  #       return current_subscription
  #     else
  #       current_subscription.errors.full_messages.each{|err| errors.add(:base, err) unless errors.full_messages.include?(err) }
  #       return false
  #     end
  #   end
  #   current_subscription
  # end

  # Chargify subscriptions management
  def subscription_params(product_id)
    attrs = { :product_id => product_id }
    current_customer = customer
    if current_customer
      attrs.merge!({ :customer_id => current_customer.id })
    else
      attrs.merge!({ :customer_attributes => customer_attributes })
    end
    attrs.merge!({ :credit_card_attributes => credit_card_attributes }) if valid_credit_card?
    attrs
  end

  def customer_attributes
    attrs = {
      :first_name   => owner.name_first,
      :last_name    => owner.name_last,
      :email        => billing_email,
      :reference    => owner_id,
      :organization => name
    }
    attrs
  end

  def credit_card_attributes
    {
      :first_name       => billing_first_name,
      :last_name        => billing_last_name,
      :expiration_month => credit_card[:expiration_month],
      :expiration_year  => credit_card[:expiration_year],
      :full_number      => credit_card[:credit_card_number],
      :cvv              => credit_card[:cvv]
    }
  end

  def valid_credit_card?
    unless credit_card.nil?
      return !credit_card[:expiration_month].blank? && !credit_card[:expiration_year].blank? &&
              !credit_card[:credit_card_number].blank? && !credit_card[:cvv].blank?
    end
    false
  end
  
  def transliterate_file_name
    extension = File.extname(logo_file_name).gsub(/^\.+/, '')
    extension = Utilities::Filename.transliterate(extension)
    filename = logo_file_name.gsub(/\.#{extension}$/, '')
    filename = Utilities::Filename.transliterate(filename)
    self.logo.instance_write(:file_name, "#{filename}.#{extension}")
  end

  ### Update Location index if Organization is modified

  # mark location for solr indexing if certain organization attributes is updated
  
  def update_locations_index
    if !self.locations.empty? && self.changed?
      # is any of the updated attributes indexed on location?
      if self.changed.detect { |field| ["name", "categories", "is_student_friendly", "is_motorcoach_friendly", "keywords"].include?(field) }
        for location in self.locations
          location.index
        end
      end
    end
  end

  # remove all location for this organization from solr index
  def remove_locations_index
    unless self.locations.empty?
      for location in self.locations
        location.remove_from_index
      end
    end
  end
  
  def account_typing
    if self.account_type_id.blank? and self.changed?
      if self.categories.any? {|c| c.tipe != 'provider'} 
        #self.update_attribute(:account_type_id, AccountType.find_by_is_trial(true).id)
        self.account_type = AccountType.where(:is_trial => true).first
        #don't set trial info if values exist.  Reason: prevent user from claim, cancel, claim to get extended trial.
        if self.trial_started_at.blank?
          self.trial_started_at = Time.now
        end
        if self.trial_ends_at.blank?
          self.trial_ends_at = 30.days.since(Time.now)
        end
      elsif self.categories.any? {|c| c.tipe == 'provider'} 
        self.update_attribute(:account_type_id, AccountType.find_by_is_travel_provider(true).id)
      end
    end
 
  end

  def trial_message
    if self.owner_id and !self.trial_message_sent?
      user = User.find(self.owner_id)
      if self.categories and self.categories.any?{ |t| t.tipe == "provider"}
        new_note = user.notes.create(:is_fancybox_autoload => true, :is_sysmessage => true, :subject => "Thank you for claiming #{self.name}!", :permalink => "travel_planner")  
      elsif self.categories and self.categories.any?{ |t| t.tipe == "supplier"}
        new_note = user.notes.create(:is_fancybox_autoload => true, :is_sysmessage => true, :subject => "What would you say to 30 days for free?", :permalink => "trial")
      end
      self.update_attribute(:trial_message_sent, true)
    end
  end  
  def allow_only_images
    if !(logo.content_type =~ %r{^(image|(x-)?application)/(x-png|pjpeg|jpeg|jpg|png|gif)$})
      return false 
    end
  end 
end