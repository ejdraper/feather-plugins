require File.join(File.join(File.dirname(__FILE__), "controllers"), "comments")
require File.join(File.join(File.dirname(__FILE__), "models"), "comment")

Hooks::Routing.add_route do
  { :url => "/comments/create", :controller => "Comments", :action => "create" }
end

# We need a way to pass these both in to the same block. Don't why?

Hooks::View.register_view do
  { :name => "after_post", :partial => "comments" }
end

Hooks::View.register_view do
  { :name => "meta_section", :partial => "comments" }
end