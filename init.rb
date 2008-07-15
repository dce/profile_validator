# Include hook code here
require File.dirname(__FILE__) + '/lib/profile_validator'
ActiveRecord::Base.send :include, Viget::ProfileValidator
