gem "builder"
require "builder"
require File.join(File.dirname(__FILE__), "controllers", "feeds")
require File.join(File.dirname(__FILE__), "controllers", "admin", "feed_settings")
require File.join(File.dirname(__FILE__), "helpers", "global_helpers")
require File.join(File.dirname(__FILE__), "models", "feather", "feed_setting")

include Merb::GlobalHelpers

Merb::Router.prepend do |r|
  r.match("/articles.:format").to(:controller => "Feather::Feeds", :action => "articles")
  r.match("/rss").to(:controller => "Feather::Feeds", :action => "articles", :format => "rss")
  r.match("/atom").to(:controller => "Feather::Feeds", :action => "articles", :format => "atom")
  r.match("/comments.:format").to(:controller => "Feather::Feeds", :action => "comments")
  r.namespace "feather/admin", :path => "admin", :name_prefix => "admin" do
    r.resource :feed_settings
  end
end

Feather::Hooks::View.register_partial_view "head", "feed_link"
Feather::Hooks::View.register_partial_view "sidebar", "feed_link"

Feather::Hooks::Menu.add_menu_item "Feed Settings", "/admin/feed_settings"

Merb.add_mime_type(:atom, nil, %w[application/atom+xml], :charset => "utf-8")
Merb.add_mime_type(:rss,  nil, %w[application/rss+xml],  :charset => "utf-8")
