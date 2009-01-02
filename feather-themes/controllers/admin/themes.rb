module Feather
  module Admin
    class Themes < Base
      include_plugin_views __FILE__

      def index
        @themes = Feather::Theme.all
        @default_theme = Feather::PluginSetting.read('theme')
        display @themes
      end
    
      def new
        @theme = Feather::Theme.new
        render
      end
    
      def set_default
        if params[:default_theme] && Feather::Theme.get(params[:default_theme])
          Feather::PluginSetting.write('theme', params[:default_theme])
        end
        redirect url(:admin_themes)
      end
    
      def create
        if params[:theme][:url]
          Feather::Theme.install(params[:theme][:url])
          redirect url(:admin_themes)
        else
          render :action => 'new'
        end
      end
    
      def delete
        Feather::Theme.get(params[:id]).destroy
        redirect url(:admin_themes)
      end
    end
  end
end