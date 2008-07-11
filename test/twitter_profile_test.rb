require File.dirname(__FILE__) + '/test_helper'

class TwitterProfileTest < Test::Unit::TestCase

  context "A new Twitter profile" do

    should "require a Twitter URL" do
      profile = TwitterProfile.new(:url => 'http://www.example.com')
      assert_equal profile.valid?, false
      assert_equal profile.errors["url"], "does not match indicated website"
    end
    
    context "with a Twitter URL" do
      
      setup do
        @user = User.create(:name => 'Test User')
        info = stub(:properties => ['url'], :url => @user.url_for_profile)
        HCard.stubs(:find).with('http://www.twitter.com/testuser').returns([info])
      end
      
      should "work if user's URL is in Twitter profile" do
        profile = TwitterProfile.create(:profileable => @user, :url => 'http://www.twitter.com/testuser')
        assert profile.valid?
      end
    
      should "be unique for a given user" do
        TwitterProfile.create(:profileable => @user, :url => 'http://www.twitter.com/testuser')
        profile = TwitterProfile.new(:profileable => @user, :url => 'http://www.twitter.com/testuser')
        assert_equal profile.valid?, false
        assert_equal profile.errors["url"], "has already been taken"
      end
      
      should "require user's URL to be in Twitter profile" do
        profile = TwitterProfile.new(:profileable => User.create, :url => 'http://www.twitter.com/testuser')
        assert_equal profile.valid?, false
        assert_equal profile.errors["url"], "is not owned by user"
      end
      
    end
  end
end