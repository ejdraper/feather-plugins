require File.join(File.join(File.dirname(__FILE__), "lib"), "comment")
require File.join(File.join(File.dirname(__FILE__), "models"), "jabber_setting")
require File.join(File.join(File.join(File.dirname(__FILE__), "controllers"), "admin"), "jabber_settings")
<<<<<<< HEAD:feather-jabber/init.rb
gem "xmpp4r"
require "xmpp4r"
include Jabber
=======
>>>>>>> 29654722a21eea2b9d2b65d99c979af384f5f365:feather-jabber/init.rb

# This will ensure feather-comments is loaded first.
PluginDependencies::register_dependency "feather-comments"

Hooks::Menu.add_menu_item "Jabber Settings", "/admin/jabber_settings"

Merb::Router.prepend do |r|
  r.namespace :admin do |admin|
    admin.resource :jabber_settings
  end
end
