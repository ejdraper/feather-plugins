module Merb
  module GlobalHelpers
    def feed_url
      feed_settings = FeedSetting.current
      (feed_settings.external_feed_url.nil? || feed_settings.external_feed_url == "") ? "http://#{request.env['HTTP_HOST']}/articles.rss" : feed_settings.external_feed_url
    end
  end
end