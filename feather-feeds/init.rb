require File.join(File.dirname(__FILE__), "controllers", "feeds")
require File.join(File.dirname(__FILE__), "controllers", "admin", "feed_settings")
require File.join(File.dirname(__FILE__), "models", "feather", "feed_setting")

Feather::Hooks::Routing.register_route do |r|
  r.match("/feeds/:action.:format").to(:controller => "feeds").name(:feeds)
  r.namespace "admin", :path => "admin", :name_prefix => "admin" do
    r.resource :feed_setting, :path => "admin/feed_setting", :name_prefix => "admin", :controller => "admin/feed_settings"
  end
end

Feather::Hooks::View.register_partial_view "head", "feed_link"
Feather::Hooks::View.register_partial_view "sidebar", "feed_link"

Feather::Hooks::Menu.add_menu_item "Feed Settings", "/admin/feed_setting"

Merb.add_mime_type(:atom, nil, %w[application/atom+xml], :charset => "utf-8")
Merb.add_mime_type(:rss,  nil, %w[application/rss+xml],  :charset => "utf-8")
