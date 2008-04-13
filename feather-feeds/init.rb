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

Hooks::View.register_partial_view "head", "feed_link"
Hooks::View.register_partial_view "sidebar", "feed_link"

Hooks::Menu.add_menu_item "Feed Settings", "/admin/feed_settings"