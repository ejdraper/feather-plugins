require File.join(File.join(File.dirname(__FILE__), "controllers"), "comments")
require File.join(File.join(File.dirname(__FILE__), "models"), "comment")

Merb::Router.prepend do |r|
  r.resources :comments
end

Hooks::View.register_view do
  [{ :name => "after_post", :partial => "comments" },
  { :name => "meta_section", :partial => "comments" }]
end