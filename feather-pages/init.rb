require File.join(File.join(File.join(File.dirname(__FILE__), "controllers"), "admin"), "pages")
require File.join(File.join(File.dirname(__FILE__), "controllers"), "pages")
require File.join(File.join(File.dirname(__FILE__), "models"), "page")

Merb::Router.prepend do |r|
  r.match("/page/:id").to(:controller => "pages", :action => "show").name(:page)
  r.namespace :admin do |admin|
    admin.resources :pages
  end
end

Hooks::View.register_partial_view "head", "page_meta"
Hooks::View.register_partial_view "sidebar", "pages_sidebar"

Hooks::Menu.add_menu_item "Pages", "/admin/pages"