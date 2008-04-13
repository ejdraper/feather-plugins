require File.join(File.join(File.dirname(__FILE__), "controllers"), "sidebar_groups")
require File.join(File.join(File.dirname(__FILE__), "models"), "sidebar_group")

Merb::Router.prepend do |r|
  r.namespace :admin do |admin|
    admin.resources :sidebar_groups
  end
end

Hooks::Menu.add_menu_item "Sidebar", "/admin/sidebar_groups"

Hooks::View.register_partial_view "sidebar", "sidebar_groups"