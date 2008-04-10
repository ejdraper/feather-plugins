require File.join(File.join(File.dirname(__FILE__), "controllers"), "feeds")
gem "builder"

Merb::Router.prepend do |r|
  r.match("/articles.rss").to(:controller => "Feeds", :action => "articles")
  r.match("/rss").to(:controller => "Feeds", :action => "articles")
  r.match("/comments.rss").to(:controller => "Feeds", :action => "comments")
end

Hooks::Menu.add_menu_item do
  {:text => "Feed", :url => "articles.rss" }
end

Hooks::View.register_view do
  { :name => "head", :partial => "feed_link" },
  { :name => "sidebar", :partial => "feed_link" }
end