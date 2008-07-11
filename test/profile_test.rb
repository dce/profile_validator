require File.dirname(__FILE__) + '/test_helper'

class ProfileTest < Test::Unit::TestCase

  context "A new Profile" do

    should "require a URL" do
      profile = Profile.new
      assert_equal profile.valid?, false
      assert_equal profile.errors['url'], "can't be blank"
    end

    should "require a profileable" do
      profile = Profile.new
      assert_equal profile.valid?, false
      assert_equal profile.errors['profileable_id'], "can't be blank"
    end

    context "with an associated model" do

      setup do
        @user = User.create(:name => 'Test User')
        info = stub(:properties => ['url'], :url => @user.url_for_profile, :fn => 'Test User')
        HCard.stubs(:find).with(:first => 'http://www.example.com/testuser').returns(info)
      end

      should "work if user's URL is in profile" do
        profile = @user.profiles.create(:url => 'http://www.example.com/testuser')
        assert profile.valid?
      end

      should "be unique for a given user" do
        @user.profiles.create(:url => 'http://www.example.com/testuser')
        profile = @user.profiles.create(:url => 'http://www.example.com/testuser')
        assert_equal profile.valid?, false
        assert_equal profile.errors["url"], "has already been taken"
      end

      should "require profile URL to have user data" do
        HCard.stubs(:find).with(:first => 'http://www.microsoft.com').returns(nil)
        profile = @user.profiles.create(:url => 'http://www.microsoft.com')
        assert_equal profile.valid?, false
        assert_equal profile.errors["url"], "is not owned by user"
      end

      should "require user's URL to be in profile" do
        profile = User.create.profiles.create(:url => 'http://www.example.com/testuser')
        assert_equal profile.valid?, false
        assert_equal profile.errors["url"], "is not owned by user"
      end

      should "pass missing methods onto microformat data" do
        profile = @user.profiles.create(:url => 'http://www.example.com/testuser')
        assert_equal @user.name, profile.fn
      end

    end
  end
end
