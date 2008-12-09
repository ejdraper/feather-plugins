module Merb
  module GlobalHelpers
    def feed_url(format)
      feed_settings = ::Feather::FeedSetting.current
      (feed_settings.external_feed_url.nil? || feed_settings.external_feed_url.empty?) ? url(:feeds, :action => :articles, :format => format) : feed_settings.external_feed_url
    end
  end
end
