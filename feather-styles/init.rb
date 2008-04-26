require File.join(File.join(File.dirname(__FILE__), "controllers"), "css")
require File.join(File.join(File.dirname(__FILE__), "controllers"), "styles")
require File.join(File.join(File.dirname(__FILE__), "models"), "style")

Merb::Router.prepend do |r|
  r.namespace :admin do |admin|
    admin.resources :styles
  end
  r.match("/stylesheets/custom.css").to(:controller => "css", :action => "custom")
end

Hooks::View.register_dynamic_view "head", "<link type=\"text/css\" media=\"all\" href=\"/stylesheets/custom.css\" rel=\"Stylesheet\" charset=\"utf-8\" />"

Hooks::Menu.add_menu_item "Styles", "/admin/styles"