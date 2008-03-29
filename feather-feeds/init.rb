require File.join(File.join(File.dirname(__FILE__), "controllers"), "feeds")

Hooks::Routing.add_route do
  {:url => "/rss", :controller => "Feeds", :action => "rss" }
end

Hooks::Routing.add_route do
  {:url => "/atom", :controller => "Feeds", :action => "atom" }
end

Hooks::Menu.add_menu_item do
  {:text => "RSS", :url => "/rss" }
end

Hooks::Menu.add_menu_item do
  {:text => "ATOM", :url => "/atom" }
end