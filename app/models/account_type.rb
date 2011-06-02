class AccountType < ActiveRecord::Base
  scope :provider, where(:is_travel_provider => true)
  scope :non_provider, where(:is_travel_provider => nil)
  
  def courtesy?
    self.id == 7
  end
end
