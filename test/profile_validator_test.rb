require File.dirname(__FILE__) + '/test_helper'

class ProfileValidatorTest < Test::Unit::TestCase
  
  context "A class validating profiles" do
    
    setup do
      @user = User.create
    end
    
    should "have a profile" do
      assert_nil @user.profile
    end
    
    should "have a profile URL" do
      assert_equal @user.url_for_profile, "http://example.com/#{@user.id}"
    end

  end

  context "A class validating multiple profiles" do

    setup do
      @user = MultipleProfileUser.create
    end

    should "have multiple profiles" do
      assert_equal @user.profiles, []
    end

  end

end