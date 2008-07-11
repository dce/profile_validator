module ProfileValidator
  
  def self.included(base)
    base.class_eval do
      base.extend ClassMethods
    end
  end

  module ClassMethods
    
    def validates_profile
      has_many :profiles, :as => :profileable
      include InstanceMethods
    end
    
  end
  
  module InstanceMethods

    def url_for_profile
      "http://example.com/#{self.id}"
    end
    
  end
  
end