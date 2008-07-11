require File.dirname(__FILE__) + '/test_helper'

class ProfileValidatorTest < Test::Unit::TestCase
  
  context "A class extending ValidatesProfile" do
    
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
  
end