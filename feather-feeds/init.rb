gem "builder"
require "builder"
require File.join(File.join(File.dirname(__FILE__), "controllers"), "feeds")
require File.join(File.join(File.dirname(__FILE__), "controllers"), "feed_settings")
require File.join(File.join(File.dirname(__FILE__), "helpers"), "global_helpers")
require File.join(File.join(File.dirname(__FILE__), "models"), "feed_setting")

Merb::Router.prepend do |r|
  r.match("/articles.rss").to(:controller => "Feeds", :action => "articles")
  r.match("/rss").to(:controller => "Feeds", :action => "articles")
  r.match("/comments.rss").to(:controller => "Feeds", :action => "comments")
  r.namespace :admin do |admin|
    admin.resource :feed_settings
  end
end

Hooks::View.register_view do
  [{ :name => "head", :partial => "feed_link" },
  { :name => "sidebar", :partial => "feed_link" }]
end

Hooks::Menu.add_menu_item do
  {:text => "Feed Settings", :url => "/admin/feed_settings" }
end