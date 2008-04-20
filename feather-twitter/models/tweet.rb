class Tweet < DataMapper::Base
  property :twitter_id, :string, :nullable => false
  property :text, :string, :nullable => false, :length => 140
  property :source, :string, :nullable => false
  property :in_reply_to, :string, :length => 140
  property :username, :string, :nullable => false, :length => 255
  property :created_at, :datetime, :nullable => false
  property :published_at, :datetime, :nullable => false
  
  validates_presence_of :twitter_id, :key => "uniq_twitter_id"
  validates_presence_of :text, :key => "uniq_text"
  validates_presence_of :source, :key => "uniq_source"
  validates_presence_of :created_at, :key => "uniq_created_at"
  
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
    Tweet.all.select { |t| t.published_at < before.published_at && t.published_at > after.published_at }.select { |t| (t.reply? && settings.ignore_replies) ? false : true }
  end
  
  ##
  # This builds a direct url to the tweet
  def url
    "http://twitter.com/#{self.username}/statuses/#{self.twitter_id}"
  end
end