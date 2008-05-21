gem "builder"
require "builder"
require File.join(File.join(File.dirname(__FILE__), "controllers"), "sitemaps")

Merb::Router.prepend do |r|
  r.match("/sitemap.xml").to(:controller => "Sitemaps", :action => "index", :format => "xml")
end