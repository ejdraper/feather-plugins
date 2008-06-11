PluginDependencies::register_dependency "feather-comments"
require File.join(File.join(File.dirname(__FILE__), "helpers"), "global_helpers")
require File.join(File.join(File.join(File.dirname(__FILE__), "controllers"), "admin"), "akismet_configuration")
require File.join(File.join(File.dirname(__FILE__), "models"), "akismet_config")
require File.join(File.join(File.dirname(__FILE__), "models"), "comment")

Merb::Router.prepend do |r|
  r.namespace :admin do |admin|
    admin.resource :akismet_configuration
  end
end

Hooks::Menu.add_menu_item "Akismet", "/admin/akismet_configuration"