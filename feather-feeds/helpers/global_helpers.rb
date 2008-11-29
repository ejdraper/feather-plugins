module Merb
  module GlobalHelpers
    def feed_url(format = "rss")
      feed_settings = Feather::FeedSetting.current
      (feed_settings.external_feed_url.nil? || feed_settings.external_feed_url.empty?) ? "http://#{request.host}/articles.#{format}" : feed_settings.external_feed_url
    end
  end
end
