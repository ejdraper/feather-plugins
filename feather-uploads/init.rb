require File.join(File.join(File.join(File.dirname(__FILE__), "controllers"), "admin"), "uploads")
require File.join(File.join(File.dirname(__FILE__), "models"), "upload")

Merb::Router.prepend do |r|
  r.namespace :admin do |admin|
    admin.resources :uploads
  end
end

Hooks::Menu.add_menu_item "Uploads", "/admin/uploads"