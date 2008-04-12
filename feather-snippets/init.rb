require File.join(File.join(File.dirname(__FILE__), "controllers"), "snippets")
require File.join(File.join(File.dirname(__FILE__), "models"), "snippet")

Merb::Router.prepend do |r|
  r.namespace :admin do |admin|
    admin.resources :snippets
  end
end

Hooks::Menu.add_menu_item do
  {:text => "Snippets", :url => "/admin/snippets" }
end

Snippet.all.each do |snippet|
  snippet.register_snippet
end