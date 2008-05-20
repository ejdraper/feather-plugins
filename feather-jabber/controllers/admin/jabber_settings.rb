module Admin
  class JabberSettings < Base
    include_plugin_views __FILE__
    before :find_jabber_setting

    def show
      display @jabber_setting
    end

    def edit
      display @jabber_setting
    end

    def update(jabber_setting)
      if @jabber_setting.update_attributes(jabber_setting)
        redirect url(:admin_jabber_settings, @jabber_setting)
      else
        render :edit
      end
    end
    
    private
      def find_jabber_setting
        @jabber_setting = JabberSetting.current
      end
  end
end