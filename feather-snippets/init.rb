require File.join(File.join(File.dirname(__FILE__), "controllers"), "snippets")
require File.join(File.join(File.dirname(__FILE__), "models"), "snippet")

Merb::Router.prepend do |r|
  r.namespace :admin do |admin|
    admin.resources :snippets
  end
end

Hooks::Menu.add_menu_item "Snippets", "/admin/snippets"

Hooks::Events.register_event(:application_before) do
  Snippet.deregister_snippets
  Snippet.register_snippets
end