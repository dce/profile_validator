module Viget
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

        if options[:multiple]
          has_many :profiles, association_options
        else
          has_one :profile, association_options
        end

        class_inheritable_reader :url_format
        format = options[:url_format]
        format = [format || /^https?:\/\/\w{2,}\.\w{2,}/] unless format.is_a?(Array)
        write_inheritable_attribute(:url_format, format)

        include InstanceMethods
      end

    end
    
    module InstanceMethods
  
      def url_for_profile
        "http://example.com/#{self.id}"
      end

    end
  end
end