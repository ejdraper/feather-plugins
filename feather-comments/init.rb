require File.join(File.join(File.dirname(__FILE__), "controllers"), "comments")
require File.join(File.join(File.dirname(__FILE__), "models"), "comment")

Merb::Router.prepend do |r|
  r.resources :comments
end

Hooks::View.register_partial_view "after_article", "comments"
Hooks::View.register_partial_view "meta_section", "comments"