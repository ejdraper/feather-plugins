module Admin
  class MollomSettings < Base
    include_plugin_views __FILE__
    before :find_config

    def show
      display @mollom_config
    end

    def edit
      display @mollom_config
    end

    def update(mollom_config)
      if @mollom_config.update_attributes(mollom_config)
        redirect url(:admin_mollom_settings, @mollom_config)
      else
        render :edit
      end
    end
    
    private
      def find_config
        @mollom_config = MollomConfig.current
      end
  end
end