class Tweet
  include DataMapper::Resource
  
  property :id, Integer, :key => true
  property :twitter_id, String, :nullable => false
  property :text, String, :nullable => false, :length => 140
  property :source, String, :nullable => false, :length => 255
  property :in_reply_to, String, :length => 140
  property :username, String, :nullable => false, :length => 255
  property :created_at, DateTime, :nullable => false
  property :published_at, DateTime, :nullable => false
  
  validates_present :twitter_id, :key => "uniq_twitter_id"
  validates_present :text, :key => "uniq_text"
  validates_present :source, :key => "uniq_source"
  validates_present :created_at, :key => "uniq_created_at"
  
  ##
  # This returns true if the tweet is a reply to someone, false if it isn't
  def reply?
    !self.in_reply_to.nil?
  end
  
  ##
  # This returns the user that was being replied to if this was a reply
  def replying_to
    return nil unless self.reply?
    user = self.text[0...self.text.index(" ")]
    return nil unless user[0...1] == "@"
    user
  end

  ##
  # This provides a summary of the text update, if it's longer than 30 characters
  def text_summary
    summary = self.text
    summary = summary[(summary.index(" ") + 1)...summary.length] if self.text[0...1] == "@"
    summary = (summary.length > 30 ? "#{summary[0..30]}..." : summary[0..30])
    summary
  end
  
  ##
  # This returns any tweets found between two articles
  def self.find_between_articles(before, after)
    settings = TwitterSetting.current
    Tweet.all(:order => [:published_at.desc]).select { |t| t.published_at < before.published_at && t.published_at > after.published_at }.select { |t| (t.reply? && settings.ignore_replies) ? false : true }
  end

  ##
  # This returns any tweets newer than the specified article
  def self.find_newer_than_article(article)
    settings = TwitterSetting.current
    Tweet.all(:order => [:published_at.desc]).select { |t| t.published_at > article.published_at }.select { |t| (t.reply? && settings.ignore_replies) ? false : true }
  end

  ##
  # This returns any tweets found after the specified article
  def self.find_older_than_article(article)
    settings = TwitterSetting.current
    Tweet.all(:order => [:published_at.desc]).select { |t| t.published_at < article.published_at }.select { |t| (t.reply? && settings.ignore_replies) ? false : true }
  end
  
  ##
  # This builds a direct url to the tweet
  def url
    "http://twitter.com/#{self.username}/statuses/#{self.twitter_id}"
  end
end