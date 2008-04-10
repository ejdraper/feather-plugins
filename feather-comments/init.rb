require File.join(File.join(File.dirname(__FILE__), "controllers"), "comments")
require File.join(File.join(File.dirname(__FILE__), "models"), "comment")

Merb::Router.prepend do |r|
  r.match("/comments/create", :controller => "Comments", :action => "create")
end

Hooks::View.register_view do
  { :name => "after_post", :partial => "comments" }
  { :name => "meta_section", :partial => "comments" }
end