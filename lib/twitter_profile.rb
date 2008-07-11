class TwitterProfile < Profile
  
  protected
  
  def has_correct_url_format?
    url =~ /\Ahttp:\/\/www\.twitter\.com\/\w+\Z/
  end
  
  def fetch_profile_info
    HCard.find(url).first
  end
  
end