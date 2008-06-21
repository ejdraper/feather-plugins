class TwitterSetting
  include DataMapper::Resource
  
  property :id, Integer, :key => true
  property :username, String
  property :ignore_replies, Boolean, :nullable => false, :default => true
  property :last_scan_at, DateTime
  
  after :update, :rescan
  
  ##
  # This rescans for new Tweets, if the last scan time was more than 30 minutes ago
  def rescan
    scan if self.last_scan_at.nil? || ((self.last_scan_at.to_time + (60 * 30)) < Time.now)
    true
  end

  ##
  # This scans for new Tweets
  def scan
    # Ensure we have valid settings
    unless self.username.nil? || self.username == ""
      # Grab Twitter statuses as xml
      doc = Hpricot(Net::HTTP.get(URI.parse("http://twitter.com/statuses/user_timeline/#{self.username}.xml")))
      statuses = (doc/"statuses"/"status")
      # Loop through statuses
      statuses.each do |status|
        # Ensure it's unique, and that we don't already have it
        if Tweet.first(:twitter_id => (status/"id").first.innerText).nil?
          # Save the new tweet
          tweet = Tweet.new
          tweet.twitter_id = (status/"id").first.innerText
          tweet.text = (status/"text").first.innerText
          tweet.source = (status/"source").first.innerText
          tweet.in_reply_to = ((status/"in_reply_to").first.nil? || (status/"in_reply_to").first.innerText == "") ? nil : (status/"in_reply_to").first.innerText
          tweet.username = (status/"user"/"screen_name").first.innerText
          tweet.published_at = DateTime.parse((status/"created_at").first.innerText)
          tweet.created_at = DateTime.now
          tweet.save
        end
      end
      # Set the last scan time on the settings
      self.last_scan_at = DateTime.now
      self.save
    end
    true
  end

  ##
  # This returns the current settings, creating them if they aren't already present
  def self.current
    twitter_settings = TwitterSetting.first
    twitter_settings = TwitterSetting.create(:username => nil, :ignore_replies => true) if twitter_settings.nil?
    twitter_settings
  end
end