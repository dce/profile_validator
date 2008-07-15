require File.dirname(__FILE__) + '/test_helper'

class ProfileTest < Test::Unit::TestCase

  context "A new Profile" do

    should "require a URL" do
      profile = Profile.new
      assert_equal profile.valid?, false
      assert_equal profile.errors['url'], "can't be blank"
    end

    should "require a profileable model" do
      profile = Profile.new
      assert_equal profile.valid?, false
      assert_equal profile.errors['profileable_id'], "can't be blank"
    end

    context "with an associated model" do

      setup do
        @user = User.create(:name => 'Test User')
      end

      should "should perform basic URL format validation" do
        profile = @user.create_profile(:url => 'bad url')
        assert_equal profile.valid?, false
        assert_equal profile.errors["url"], "is invalid"
      end

      should "handle nonexistent URLs gracefully" do
        HCard.stubs(:find).with(:first => 'http://www.badurl.com').raises(SocketError)
        profile = @user.create_profile(:url => 'http://www.badurl.com')
        assert_equal profile.valid?, false
        assert_equal profile.errors["url"], "is not owned by user"
      end

      should "require URL to have user data" do
        HCard.stubs(:find).with(:first => 'http://www.microsoft.com').returns(nil)
        profile = @user.create_profile(:url => 'http://www.microsoft.com')
        assert_equal profile.valid?, false
        assert_equal profile.errors["url"], "is not owned by user"
      end

      context "and a profile URL" do

        setup do
          hcard = "<div class='vcard'>" \
                  "  <span class='fn'>#{@user.name}</span>" \
                  "  <a class='url' href='#{@user.url_for_profile}'>My Homepage</a>" \
                  "</div>"
          info = HCard.find :text => hcard
          HCard.stubs(:find).with(:first => 'http://www.example.com/testuser').returns(info)
          @profile = @user.create_profile(:url => 'http://www.example.com/testuser')
        end

        should "work if user's URL is in profile" do
          assert @profile.valid?
        end

        should "be unique for a given user" do
          profile = @user.create_profile(:url => 'http://www.example.com/testuser')
          assert_equal profile.valid?, false
          assert_equal profile.errors["url"], "has already been taken"
        end

        should "require user's URL to be in profile" do
          profile = User.create.create_profile(:url => 'http://www.example.com/testuser')
          assert_equal profile.valid?, false
          assert_equal profile.errors["url"], "is not owned by user"
        end

        should "pass missing methods onto microformat data" do
          assert_equal @user.name, @user.profile.fn
        end

        should "serialize hCard information" do
          @profile.update_attribute(:url, "bad url")
          @user.reload
          assert @user.profile.hcard.instance_of?(HCard)
        end

      end

      context "limited to one site" do

        setup do
          @flickr_user = FlickrUser.create
          info = stub(:properties => ['url'], :url => @flickr_user.url_for_profile)
          HCard.stubs(:find).with(:first => 'http://www.flickr.com/people/flickruser').returns(info)
        end

        should "work if URL matches pattern" do
          profile = @flickr_user.create_profile(:url => 'http://www.flickr.com/people/flickruser')
          assert profile.valid?
        end

        should "require profile URL to match specified pattern" do
          profile = @flickr_user.create_profile(:url => 'http://www.example.com/testuser')
          assert_equal profile.valid?, false
          assert_equal profile.errors["url"], "is invalid"
        end

      end
    end
  end
end
