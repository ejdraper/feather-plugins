module Feather
  module Admin
    class FeedSettings < Base
      include_plugin_views __FILE__
      before :find_feed_setting

      def show
        display @feed_setting
      end

      def edit
        display @feed_setting
      end

      def update(feed_setting)
        if @feed_setting.update_attributes(feed_setting)
          redirect url(:admin_feed_setting)
        else
          render :edit
        end
      end
    
      private
        def find_feed_setting
          @feed_setting = Feather::FeedSetting.current
        end
    end
  end
end