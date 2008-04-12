require File.join(File.join(File.dirname(__FILE__), "controllers"), "css")
require File.join(File.join(File.dirname(__FILE__), "controllers"), "styles")
require File.join(File.join(File.dirname(__FILE__), "models"), "style")

Merb::Router.prepend do |r|
  r.namespace :admin do |admin|
    admin.resources :styles
  end
  r.match("/stylesheets/custom.css").to(:controller => "css", :action => "custom")
end

Hooks::Menu.add_menu_item do
  {:text => "Styles", :url => "/admin/styles" }
end

Hooks::View.register_view do
  {:name => "head", :content => "<link type=\"text/css\" media=\"all\" href=\"/stylesheets/custom.css\" rel=\"Stylesheet\" charset=\"utf-8\" />"}
end