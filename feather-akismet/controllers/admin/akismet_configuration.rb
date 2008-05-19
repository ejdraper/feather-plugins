module Admin
  class AkismetConfiguration < Base
    include_plugin_views __FILE__
    before :find_config

    def show
      display @akismet_config
    end

    def edit
      display @akismet_config
    end

    def update(akismet_config)
      if @akismet_config.update_attributes(akismet_config)
        redirect url(:admin_akismet_configuration, @akismet_config)
      else
        render :edit
      end
    end
    
    private
      def find_config
        @akismet_config = AkismetConfig.current
      end
  end
end