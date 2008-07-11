module ProfileValidator
  
  def self.included(base)
    base.class_eval do
      base.extend ClassMethods
    end
  end

  module ClassMethods
    
    def validates_profile(options = {})
      association_options = { :as => :profileable }
      association_options[:class_name] = options[:site].camelcase + 'Profile' if options[:site]
      has_many :profiles, association_options
      include InstanceMethods
    end
    
  end
  
  module InstanceMethods

    def url_for_profile
      "http://example.com/#{self.id}"
    end
    
  end
  
end