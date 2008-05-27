require File.join(File.join(File.join(File.dirname(__FILE__), "controllers"), "admin"), "releases")
require File.join(File.join(File.dirname(__FILE__), "models"), "release")

Merb::Router.prepend do |r|
  r.namespace :admin do |admin|
    admin.resources :releases
  end
end

Hooks::Menu.add_menu_item "Releases", "/admin/releases"