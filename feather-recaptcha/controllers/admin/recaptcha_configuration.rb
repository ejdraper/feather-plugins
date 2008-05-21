module Admin
  class RecaptchaConfiguration < Base
    include_plugin_views __FILE__
    before :find_config

    def show
      display @recaptcha_config
    end

    def edit
      display @recaptcha_config
    end

    def update(recaptcha_config)
      if @recaptcha_config.update_attributes(recaptcha_config)
        redirect url(:admin_recaptcha_configuration, @recaptcha_config)
      else
        render :edit
      end
    end
    
    private
      def find_config
        @recaptcha_config = RecaptchaConfig.current
      end
  end
end