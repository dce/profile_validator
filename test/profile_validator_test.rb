require File.dirname(__FILE__) + '/test_helper'

class ProfileValidatorTest < Test::Unit::TestCase
  
  context "A class validating profiles" do
    
    setup do
      @user = User.create
    end
    
    should "have profiles" do
      assert_equal @user.profiles, []
    end
    
    should "have a profile URL" do
      assert_equal @user.url_for_profile, "http://example.com/#{@user.id}"
    end

  end
  
  context "A class validating profiles from a particular site" do

    class LinkedInUser < User
      validates_profile :site => 'linked_in'
    end

    setup do
      @user = LinkedInUser.create(:name => 'Test User')
      info = stub(:properties => ['url'], :url => @user.url_for_profile)
      HResume.stubs(:find).with('http://www.linkedin.com/in/testuser').returns(stub(:contact => info))
    end

    should "create the proper Profile type by default" do
      profile = @user.profiles.create(:url => 'http://www.linkedin.com/in/testuser')
      assert profile.valid?
      assert profile.instance_of? LinkedInProfile
    end

  end

end