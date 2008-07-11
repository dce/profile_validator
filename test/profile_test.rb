require File.dirname(__FILE__) + '/test_helper'

class ProfileTest < Test::Unit::TestCase

  should "require a URL" do
    profile = FlickrProfile.new
    assert_equal profile.valid?, false
    assert_equal profile.errors['url'], "can't be blank"
  end
  
  should "require a profileable" do
    profile = FlickrProfile.new
    assert_equal profile.valid?, false
    assert_equal profile.errors['profileable_id'], "can't be blank"
  end
  
end
