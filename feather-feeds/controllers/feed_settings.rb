module Admin
  class FeedSettings < Base
    include_plugin_views __FILE__
    
    def show
      @feed_setting = FeedSetting.current
      display @feed_setting
    end
    
    def edit
      @feed_setting = FeedSetting.current
      display @feed_setting
    end
    
    def update(feed_setting)
      @feed_setting = FeedSetting.current
      if @feed_setting.update_attributes(feed_setting)
        redirect url(:admin_feed_settings, @feed_setting)
      else
        render :edit
      end
    end
  end
end