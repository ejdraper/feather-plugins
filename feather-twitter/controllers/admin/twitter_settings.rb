module Admin
  class TwitterSettings < Base
    include_plugin_views __FILE__
    before :find_twitter_setting

    def show
      display @twitter_setting
    end

    def edit
      display @twitter_setting
    end

    def update
      res = true
      res = @twitter_setting.update_attributes(params[:twitter_setting]) unless params[:twitter_setting].nil?
      if res
        @twitter_setting.scan if params[:force] && params[:force] == "true"
        expire_index
        redirect url(:admin_twitter_settings, @twitter_setting)
      else
        render :edit
      end
    end
    
    private
      def find_twitter_setting
        @twitter_setting = TwitterSetting.current
      end
  end
end