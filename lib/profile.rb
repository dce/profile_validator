require 'mofo'

class Profile < ActiveRecord::Base
  belongs_to :profileable, :polymorphic => true
  
  validates_presence_of :url, :profileable_id, :profileable_type
  validates_uniqueness_of :url, :scope => [:profileable_id, :profileable_type]
  validate :validate_url
  
  protected
  
  def validate_url
    validate_correct_url_format and validate_profile_ownership unless self.url.blank?
  end
  
  def validate_correct_url_format
    valid = self.has_correct_url_format?
    errors.add(:url, "does not match indicated website") unless valid
    valid
  end
  
  def validate_profile_ownership
    info = self.fetch_profile_info
    valid = (info.properties.include? 'url' and info.url and info.url.include? self.profileable.url_for_profile)
    errors.add(:url, "is not owned by user") unless valid
    valid
  end
  
end
