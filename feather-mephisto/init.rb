require File.join(File.join(File.dirname(__FILE__), "controllers"), "mephisto")

Merb::Router.prepend do |r|
  r.namespace :admin do |admin|
    admin.resource :mephisto
  end
end

Hooks::Menu.add_menu_item "Mephisto", "/admin/mephisto"