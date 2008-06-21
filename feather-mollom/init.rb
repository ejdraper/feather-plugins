PluginDependencies::register_dependency "feather-comments"
require File.join(File.dirname(__FILE__), "controllers", "admin", "mollom_settings")
require File.join(File.dirname(__FILE__),  "gems", "mollom-0.1.2", "lib", "mollom")
require File.join(File.dirname(__FILE__), "models", "mollom_config")
require File.join(File.dirname(__FILE__), "models", "comment")

Merb::Router.prepend do |r|
  r.namespace :admin do |admin|
    admin.resource :mollom_settings
  end
end

Hooks::Menu.add_menu_item "Mollom", "/admin/mollom_settings"