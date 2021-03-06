require 'mofo'

class Profile < ActiveRecord::Base
  belongs_to :profileable, :polymorphic => true
  
  validates_presence_of :url, :profileable_id, :profileable_type
  validates_uniqueness_of :url, :scope => [:profileable_id, :profileable_type]
  validate :validate_url
  
  serialize :hcard

  def method_missing(symbol, *args)
    begin
      super(symbol, *args)
    rescue NoMethodError
      data.send(symbol, *args)
    end
  end

  protected
  
  def data
    self.hcard ||= HCard.find :first => url rescue nil
  end
  
  def is_owned?
    data && data.properties.include?('url') && data.url && data.url.include?(self.profileable.url_for_profile)
  end

  def validate_url
    validate_url_format && validate_profile_ownership unless self.profileable.blank?
  end

  def validate_url_format
    valid = self.profileable.class.url_format.detect {|format| self.url =~ format }
    errors.add(:url, "is invalid") unless valid
    valid
  end
  
  def validate_profile_ownership
    errors.add(:url, "is not owned by user") unless valid = is_owned?
    valid
  end
  
end
