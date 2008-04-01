require File.join(File.join(File.dirname(__FILE__), "controllers"), "comments")

Hooks::Routing.add_route do
  { :url => "/comments/create", :controller => "Comments", :action => "create" }
end

Hooks::View.register_view do
  { :name => "after_post", :partial => "comments" }
end