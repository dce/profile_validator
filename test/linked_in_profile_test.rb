require File.dirname(__FILE__) + '/test_helper'

class LinkedInProfileTest < Test::Unit::TestCase

  context "A new LinkedIn profile" do

    should "require a LinkedIn URL" do
      profile = LinkedInProfile.new(:url => 'http://www.example.com')
      assert_equal profile.valid?, false
      assert_equal profile.errors["url"], "does not match indicated website"
    end
    
    context "with a LinkedIn URL" do
      
      setup do
        @user = User.create(:name => 'Test User')
        info = stub(:properties => ['url'], :url => @user.url_for_profile)
        HResume.stubs(:find).with('http://www.linkedin.com/in/testuser').returns(stub(:contact => info))
      end
      
      should "work if user's URL is in LinkedIn profile" do
        profile = LinkedInProfile.create(:profileable => @user, :url => 'http://www.linkedin.com/in/testuser')
        assert profile.valid?
      end
    
      should "be unique for a given user" do
        LinkedInProfile.create(:profileable => @user, :url => 'http://www.linkedin.com/in/testuser')
        profile = LinkedInProfile.new(:profileable => @user, :url => 'http://www.linkedin.com/in/testuser')
        assert_equal profile.valid?, false
        assert_equal profile.errors["url"], "has already been taken"
      end
      
      should "require user's URL to be in LinkedIn profile" do
        profile = LinkedInProfile.new(:profileable => User.create, :url => 'http://www.linkedin.com/in/testuser')
        assert_equal profile.valid?, false
        assert_equal profile.errors["url"], "is not owned by user"
      end
      
    end
  end
end