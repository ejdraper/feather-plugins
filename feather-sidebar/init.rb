require File.join(File.join(File.dirname(__FILE__), "controllers"), "sidebar_groups")
require File.join(File.join(File.dirname(__FILE__), "models"), "sidebar_group")

Merb::Router.prepend do |r|
  r.namespace :admin do |admin|
    admin.resources :sidebar_groups
  end
end

Hooks::Menu.add_menu_item do
  {:text => "Sidebar", :url => "/admin/sidebar_groups" }
end

Hooks::View.register_view do
  { :name => "sidebar", :partial => "sidebar_groups" }
end

