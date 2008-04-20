module Admin
  class TwitterSettings < Base
    include_plugin_views __FILE__
    
    def show
      @twitter_setting = TwitterSetting.current
      display @twitter_setting
    end
    
    def edit
      @twitter_setting = TwitterSetting.current
      display @twitter_setting
    end
    
    def update
      @twitter_setting = TwitterSetting.current
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
  end
end