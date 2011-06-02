class Asset < ActiveRecord::Base
  before_validation :clear_file
  belongs_to :assetable, :polymorphic => true
  attr_accessor :delete_file, :organization_id

  #Paperclip Gem
  has_attached_file :file,
    :styles => {
        :large => "200x200>",
        :medium => "100x100>"
    },
    :storage => :s3,
    :s3_credentials => "#{::Rails.root.to_s}/config/s3.yml",
    :path => ":attachment/:id/:style/:basename.:extension",
    :bucket => "itoursmart-#{Rails.env}"
  validates_attachment_content_type :file, :content_type => ['image/jpeg', 'image/png', 'image/gif', 'application/pdf', 'application/vnd.openxmlformats-officedocument.wordprocessingml.document', 'application/msword', 'application/vnd.ms-excel', 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet', "image/pjpeg", "image/x-png", "image/x-citrix-pjpeg", "image/x-citrix-gif"], :message => "should be \"PNG, GIF, or JPG\""
  validates_attachment_size :file, :less_than => 5.megabytes, :message => "must be less than 2MB"
  before_post_process :allow_only_images
  before_post_process :transliterate_file_name
  
  
  def clear_file
    self.destroy if self.delete_file == "1" && !self.file.dirty?
  end

  def transliterate_file_name
    extension = File.extname(file_file_name).gsub(/^\.+/, '')
    extension = Utilities::Filename.transliterate(extension)
    filename = file_file_name.gsub(/\.#{extension}$/, '')
    filename = Utilities::Filename.transliterate(filename)
    self.file.instance_write(:file_name, "#{filename}.#{extension}")
  end
  
  def allow_only_images
    if !(file.content_type =~ %r{^(image|(x-)?application)/(x-png|pjpeg|jpeg|jpg|png|gif)$})
      return false 
    end
  end 
  
end
