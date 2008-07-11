require File.dirname(__FILE__) + '/test_helper'

class FlickrProfileTest < Test::Unit::TestCase

  context "A new Flickr profile" do

    should "require a Flickr URL" do
      profile = FlickrProfile.new(:url => 'http://www.example.com')
      assert_equal profile.valid?, false
      assert_equal profile.errors["url"], "does not match indicated website"
    end
    
    context "with a Flickr URL" do
      
      setup do
        @user = User.create(:name => 'Test User')
        info = stub(:properties => ['url'], :url => @user.url_for_profile)
        HCard.stubs(:find).with('http://www.flickr.com/people/testuser').returns(info)
      end
      
      should "work if user's URL is in Flickr profile" do
        profile = FlickrProfile.create(:profileable => @user, :url => 'http://www.flickr.com/people/testuser')
        assert profile.valid?
      end
    
      should "be unique for a given user" do
        FlickrProfile.create(:profileable => @user, :url => 'http://www.flickr.com/people/testuser')
        profile = FlickrProfile.new(:profileable => @user, :url => 'http://www.flickr.com/people/testuser')
        assert_equal profile.valid?, false
        assert_equal profile.errors["url"], "has already been taken"
      end
      
      should "require user's URL to be in Flickr profile" do
        profile = FlickrProfile.new(:profileable => User.create, :url => 'http://www.flickr.com/people/testuser')
        assert_equal profile.valid?, false
        assert_equal profile.errors["url"], "is not owned by user"
      end
      
    end
  end
end