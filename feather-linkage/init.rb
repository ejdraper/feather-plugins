require File.join(File.join(File.dirname(__FILE__), "controllers"), "links")
require File.join(File.join(File.dirname(__FILE__), "models"), "link")

Merb::Router.prepend do |r|
  r.namespace :admin do |admin|
    admin.resources :links
  end
end

Hooks::Menu.add_menu_item do
  {:text => "Linkage", :url => "/admin/links" }
end

