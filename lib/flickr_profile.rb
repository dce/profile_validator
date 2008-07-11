class FlickrProfile < Profile
  
  protected
  
  def has_correct_url_format?
    url =~ /\Ahttp:\/\/www\.flickr\.com\/people\/\w+\Z/
  end
    
  def fetch_profile_info
    HCard.find(url)
  end
  
end