module Admin
  class Themes < Base
    include_plugin_views __FILE__

    def index
      @themes = Theme.all
      display @themes
    end
    
    def new
      @theme = Theme.new
      render
    end
    
    def set_default
      if params[:default_theme] and Theme.get(params[:default_theme])
        PluginSetting.write('theme', params[:default_theme])
      end
      redirect url(:admin_themes)
    end
    
    def create
      if params[:theme][:url]
        Theme.install(params[:theme][:url])
        redirect url(:admin_themes)
      else
        render :action => 'new'
      end
    end
    
    def delete
      Theme.get(params[:id]).destroy
      redirect url(:admin_themes)
    end
  end
end