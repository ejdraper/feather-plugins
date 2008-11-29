module Feather
  class FeedSetting
    include DataMapper::Resource
  
    property :id, Integer, :serial => true
    property :article_count, Integer
    property :comment_count, Integer
    property :external_feed_url, String, :length => 255

    ##
    # This returns the current settings, creating them if they aren't found
    def self.current
      feed_settings = Feather::FeedSetting.first
      feed_settings = Feather::FeedSetting.create(:article_count => 15, :comment_count => 15, :external_feed_url => nil) if feed_settings.nil?
      feed_settings
    end
  end
end