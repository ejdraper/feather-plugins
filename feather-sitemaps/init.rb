gem "builder"
require "builder"
require File.join(File.dirname(__FILE__), "controllers", "sitemaps")

Merb::Router.prepend do |r|
  r.match("/sitemap.xml").to(:controller => "feather/sitemaps", :action => "index", :format => "xml")
end