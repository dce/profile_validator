unless defined?(ProfileValidator)

  require 'rubygems'
  require 'active_record'
  require 'test/unit'
  require 'shoulda'
  require 'mocha'
  
  require File.dirname(__FILE__) + "/../init"
  
  ['profile', 'profile_validator'].each do |file|
    require File.dirname(__FILE__) + "/../lib/#{file}"
  end
  
  config = open(File.dirname(__FILE__) + "/config.yml") { |f| YAML.load(f.read) }
  ActiveRecord::Base.establish_connection(config["database"])
  
  ActiveRecord::Base.connection.drop_table :users rescue nil
  ActiveRecord::Base.connection.drop_table :profiles rescue nil
  
  ActiveRecord::Base.connection.create_table :users do |t|
    t.string :name
    t.string :type
  end

  ActiveRecord::Base.connection.create_table :profiles do |t|
    t.string  :type
    t.integer :profileable_id
    t.string  :profileable_type
    t.string  :url
    t.timestamps
  end
  
  class User < ActiveRecord::Base
    validates_profile
  end

  class FlickrUser < User
    validates_profile :url_format => /^http:\/\/www\.flickr\.com\/people\/\w+$/
  end

end