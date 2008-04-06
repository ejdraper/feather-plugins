require File.join(File.join(File.dirname(__FILE__), "controllers"), "feeds")
require "builder"

Hooks::Routing.add_route do
  {:url => "/rss", :controller => "Feeds", :action => "rss" }
end

Hooks::Menu.add_menu_item do
  {:text => "Feed", :url => "/rss" }
end

Hooks::View.register_view do
  { :name => "head", :partial => "feed_link" }
end  

Hooks::View.register_view do
  { :name => "sidebar", :partial => "feed_link" }
end  

