class LinkedInProfile < Profile
  
  protected
  
  def has_correct_url_format?
    url =~ /\Ahttp:\/\/www\.linkedin\.com\/in\/\w+\Z/
  end
  
  def fetch_profile_info
    HResume.find(url).contact
  end
  
end