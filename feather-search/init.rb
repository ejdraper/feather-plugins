require File.join(File.join(File.dirname(__FILE__), "controllers"), "search")

include Merb::Cache::ControllerInstanceMethods
Merb::Router.prepend do |r|
  r.match('/search').to(:controller => 'search', :action =>'articles').name(:search)
end

Hooks::View.register_partial_view "sidebar", "search_bar"