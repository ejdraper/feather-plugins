gem "builder"
require "builder"
require File.join(File.dirname(__FILE__), "controllers", "sitemaps")

Feather::Hooks::Routing.register_route do |r|
  r.match("/sitemap.xml").to(:controller => "sitemaps", :action => "index", :format => "xml")
end