require 'mofo'

class Profile < ActiveRecord::Base
  belongs_to :profileable, :polymorphic => true
  
  validates_presence_of :url, :profileable_id, :profileable_type
  validates_uniqueness_of :url, :scope => [:profileable_id, :profileable_type]
  validate :validate_profile_ownership
  
  def method_missing(symbol, *args)
    begin
      super(symbol, *args)
    rescue NoMethodError
      data.send(symbol, *args)
    end
  end

  protected
  
  def data
    @data ||= HCard.find :first => url
  end
  
  def is_owned?
    self.data and self.data.properties.include? 'url' and self.data.url and self.data.url.include? self.profileable.url_for_profile
  end
  
  def validate_profile_ownership
    errors.add(:url, "is not owned by user") unless self.url.blank? or is_owned?
  end
  
end
