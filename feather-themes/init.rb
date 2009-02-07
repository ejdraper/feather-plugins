require File.join(File.dirname(__FILE__), "controllers", "admin", "themes")
require File.join(File.dirname(__FILE__), 'models', "feather", 'theme')

Feather::Hooks::Routing.register_route do |r|
  r.match('/admin/themes/set_default').to(:controller => 'admin/themes', :action => 'set_default')
  r.namespace "admin", :path => "admin", :name_prefix => "admin" do
    r.resources :themes, :path => "admin/themes", :name_prefix => "admin", :controller => "admin/themes"
  end
end

Merb.push_path(:themes, File.join(Merb.dir_for(:root), 'app', 'themes'), nil)
Feather::Hooks::Menu.add_menu_item "Themes", "/admin/themes"

module Feather
  module Plugins
    module Themes
      module ApplicationMixin
        def self.included(base)
          base._template_roots << [Merb.dir_for(:themes), :_theme_template_location]
        end
        
        def _theme_template_location(action, type = nil, controller = controller_name)
          if Feather::Plugin.get("feather-themes").active
            theme = Feather::PluginSetting.read('theme')
            template = "#{theme}/views/#{controller}/#{action}.#{type}"
          else
            template = "views/#{controller}/#{action}.#{type}"
          end
        end
      end
    end
  end
end

# Add a constantize method to string
class String
  def constantize
    const = nil
    self.split("::").each do |chunk|
      const = const.nil? ? Object.const_get(chunk) : const.const_get(chunk)
    end
    const
  rescue
    nil
  end
end

Feather::Application.subclasses_list.each { |c| c.constantize.send(:include, Feather::Plugins::Themes::ApplicationMixin) }