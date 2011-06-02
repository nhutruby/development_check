class Announcement < ActiveRecord::Base
  validates :message, :presence => true
  validates :starts_at, :presence => true
  validates :ends_at, :presence => true
  scope :active, lambda { { :conditions => ['starts_at <= ? AND ends_at >= ?', Time.now.utc, Time.now.utc] } }
  scope :since, lambda { |hide_time| { :conditions => (hide_time ? ['updated_at > ? OR starts_at > ?', hide_time.utc, hide_time.utc] : nil) } }
  

  def self.current_announcements(hide_time)
    active.since(hide_time)
  end
end
