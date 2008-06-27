require File.join(File.dirname(__FILE__), "controllers", "admin", "themes")
require File.join(File.dirname(__FILE__), 'models', 'theme')

Merb::Router.prepend do |r|
  r.match('/admin/themes/set_default').to(:controller => 'admin/themes', :action => 'set_default')
  r.namespace :admin do |admin|
    admin.resources :themes
  end
end

Merb.push_path(:themes, File.join(Merb.dir_for(:root), 'themes'), nil)
Hooks::Menu.add_menu_item "Themes", "/admin/themes"

module Feather
  module Plugins
    module Themes
      module ApplicationMixin
        def self.included(base)
          base._template_roots << [Merb.dir_for(:themes), :_theme_template_location]
        end
        
        def _theme_template_location(action, type = nil, controller = controller_name)
          theme = PluginSetting.read('theme')
          template = "#{theme}/views/#{controller}/#{action}.#{type}"
        end
      end
    end
  end
end

Application.subclasses_list.each { |c| c.constantize.send(:include, Feather::Plugins::Themes::ApplicationMixin) }
