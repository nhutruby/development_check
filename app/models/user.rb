class User < ActiveRecord::Base
  require 'iconv'
  include ActionView::Helpers::UrlHelper
  include Rails.application.routes.url_helpers

  # Include default devise modules. Others available are:
  # :token_authenticatable, :lockable and :timeoutable
  devise :invitable, :database_authenticatable, :registerable,# :confirmable,
         :recoverable, :rememberable, :trackable, :validatable

  attr_accessor :crop_x, :crop_y, :crop_w, :crop_h, :delete_avatar, :title

  #validates_associated :contact_methods
  validates :is_travel_planner, :inclusion => { :in => [true,false], :message => "must be selected"}
  validates_uniqueness_of :email
  validates :name_first, :presence => true
  validates :name_last, :presence => true

  #FRIENDSHIPS
  #has_one  :friendship, :foreign_key => "friender_id"
  #has_many :friendships, :foreign_key => "friendee_id"
  #belongs_to :invited_by, :polymorphic => true
  has_many :connections
  has_many :inverse_connections, :class_name => "Connection", :foreign_key => :connection_id
  has_many :connectionships, :through => :connections, :conditions => "is_approved = true", :source => :connectionship
  has_many :inverse_connectionships, :through => :inverse_connections, :conditions => "is_approved = true", :source => :user
  has_many :pending_connectionships, :through => :connections,  :conditions => 'is_approved = false or is_approved IS NULL', :source => :connectionship
  has_many :requested_connectionships, :through => :inverse_connections, :conditions => 'is_approved = false or is_approved IS NULL', :source => :user
  

  has_many :contact_methods, :as => :entity, :dependent => :destroy
  accepts_nested_attributes_for :contact_methods, :reject_if => proc {|a| a['address'].blank?}, :allow_destroy => true


  has_many :roles, :dependent => :destroy
  has_many :organizations, :through => :roles
  has_many :managed_organizations, :class_name => 'Organization', :foreign_key => :primary_contact_id
  has_many :owned_organizations, :class_name => 'Organization', :foreign_key => :owner_id
  has_many :notes, :through => :recipients
  has_many :sent_notes, :class_name => 'Note', :foreign_key => :sender_id
  has_many :recipients
  #has_many :addresses, :dependent => :destroy
  accepts_nested_attributes_for :roles
  accepts_nested_attributes_for :organizations
  has_many :ratings
  
  belongs_to :temp_org, :class_name => 'Organization'
  belongs_to :organization#_as_team_member, :class_name => 'Organization'

  #Paperclip Gem
  has_attached_file :avatar,
    :styles => {
        :large => "500x500>",
        :medium => "300x300#",
        :thumb => "55x55#",
        :mini => "30x30#"
    },
    :processors => [:cropper],
    :storage => :s3,
    :s3_credentials => "#{::Rails.root.to_s}/config/s3.yml",
    :path => ":attachment/:id/:style/:basename.:extension",
    :bucket => "itoursmart-#{Rails.env}"
  validates_attachment_content_type :avatar, :content_type => ['image/jpeg', 'image/png', 'image/gif', "image/pjpeg", "image/x-png", "image/x-citrix-pjpeg", "image/x-citrix-gif"], :message => "should be \"PNG, GIF, or JPG\""
  validates_attachment_size :avatar, :less_than => 5.megabytes, :message => "must be less than 2MB"

  before_post_process :transliterate_file_name

# Callbacks
  after_create :initialization
  after_update :reprocess_avatar, :if => :cropping?
  after_update :create_email
  before_validation :clear_avatar

  ### This is where I (PC) was trying to add manual activation to the process
  #def active?
    #super && self.is_active == true
  #end

  searchable do
    integer :id
    integer :sign_in_count
    text :name_first, :as => 'connections_name_first_textsubstring' do
      name_first
    end
    text :name_last, :as => 'connections_name_last_textsubstring' do
      name_last
    end
    integer :connection_ids, :multiple => true do
      inverse_connectionships.map { |user| user.id }
    end
  end

#  def search_connections(query)
#    connectionships.include(:connection).where(:connectionships => {:connection => ["name_first ILIKE ?", "#{ query }%")
#  end
  def all_connections
    connections | inverse_connections
  end

  def my_connections
    connectionships | inverse_connectionships
  end

  def full_name
    if name_first && name_last
      name_first + " " + name_last
    elsif name_first
      name_first
    elsif name_last
      name_last
    end
  end

  def name
    if name_first && name_last
      name_first + " " + name_last
    elsif name_first
      name_first
    elsif name_last
      name_last
    end
  end

  def cropping?
    !crop_x.blank? && !crop_y.blank? && !crop_w.blank? && !crop_h.blank?
  end

  def avatar_geometry(style = :original)
    @geometry ||= {}
    @geometry[style] ||= Paperclip::Geometry.from_file(avatar.url(style))
  end

  def clear_avatar
    self.avatar = nil if self.delete_avatar=="1" && !self.avatar.dirty?
  end

  def admin?
    self.its_admin?
  end

  def requested
    Friendship.all(:include => [:friender, :friendee], :conditions => ["state =? and friender_id =?", "requested", id])
  end

  def requested_friends
    friendships.find(:all, :include => [:friender, :friendee], :conditions => ["state =?", "requested"])
  end

  def approved_friends
    friendships.find(:all, :include => [:friender, :friendee], :conditions => ["state =?", "approved"])
  end

  def ignored_friends
    friendships.find(:all, :include => [:friender, :friendee], :conditions => ["state =?", "ignored"])
  end

  def friends
    friendships.all(:include => [:friender, :friendee], :conditions => ["confirmed =?", true])
  end

  def past_due_organizations
    self.organizations.where(["subscription_state = ?", "past_due"])
  end
  


  private

  def transliterate_file_name
    extension = File.extname(avatar_file_name).gsub(/^\.+/, '')
    extension = Utilities::Filename.transliterate(extension)
    filename = avatar_file_name.gsub(/\.#{extension}$/, '')
    filename = Utilities::Filename.transliterate(filename)
    self.avatar.instance_write(:file_name, "#{filename}.#{extension}")
  end

  def initialization
    days_calc = self.invited_by && self.invited_by.invitee_trial_period_days ? (Time.now + self.invited_by.invitee_trial_period_days.days) : nil
    ends_at_calc = self.invited_by.invitee_trial_period_ends_at if self.invited_by
    if ends_at_calc && days_calc
      end_at = ends_at_calc > days_calc ? ends_at_calc : days_calc
    elsif ends_at_calc
      end_at = ends_at_calc
    elsif days_calc
      end_at = days_calc
    else
      end_at = ""
    end
      
    self.update_attributes(:email_messages => true, :email_requests => true, :trial_period_ends_at => end_at)
    new_note = self.notes.create(:is_fancybox_autoload => true, :is_sysmessage => true, :subject => "Making iTourSmart Work For You", :permalink => "welcome")
    if self.is_coworker? and self.temp_org_id
      self.roles.create(:user_id => self.id, :organization_id => self.temp_org_id, :is_organization_approved => true, :is_user_approved => true, :title => self.title)
    end
  end

  def create_email
    if self.contact_methods.email.empty?
      self.contact_methods.create(:lokation => "work",:name => "email", :address => self.email)
    end
  end
  
  
    def reprocess_avatar
    avatar.reprocess!
  end
end
