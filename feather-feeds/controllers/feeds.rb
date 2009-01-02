module Feather
  class Feeds < Application
    include_plugin_views __FILE__
    before :find_feed_setting

    def articles
      @articles = Feather::Article.all(:published => true, :limit => @feed_setting.article_count, :order => [:published_at.desc])
      content_type params[:format].to_sym
      display(@articles)
    end

    def comments
      @comments = (defined?(Feather::Comment) && is_plugin_active("feather-comments")) ? Feather::Comment.all(:limit => @feed_setting.comment_count, :order => [:created_at.desc]) : []
      content_type params[:format].to_sym
      display(@articles)
    end

    private
      def find_feed_setting
        @feed_setting = Feather::FeedSetting.current
      end

      ##
      # This returns the specified time in RFC822 format
      def rfc822(time)
        time.strftime("%a, %d %b %Y %H:%M:%S GMT")
      end
  end
end