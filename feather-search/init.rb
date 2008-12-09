require File.join(File.dirname(__FILE__), "controllers", "search")

Feather::Hooks::Routing.register_route do |r|
  r.match('/search').to(:controller => 'feather/search', :action =>'articles').name(:search)
end

Feather::Hooks::View.register_partial_view "sidebar", "search_bar"