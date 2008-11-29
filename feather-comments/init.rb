require File.join(File.dirname(__FILE__), "controllers", "admin", "comments")
require File.join(File.dirname(__FILE__), "controllers", "admin", "comment_settings")
require File.join(File.dirname(__FILE__), "controllers", "comments")
require File.join(File.dirname(__FILE__), "mailers", "comment_mailer")
require File.join(File.dirname(__FILE__), "models", "feather", "comment")
require File.join(File.dirname(__FILE__), "models", "feather", "comment_setting")

Feather::Hooks::Routing.register_route do |r|
  r.resources :comments, :controller => "feather/comments"
  r.namespace "feather/admin", :path => "admin", :name_prefix => "admin" do
    r.resources :comments
    r.resource :comment_setting
  end
end

Feather::Hooks::View.register_partial_view "after_article", "comments"
Feather::Hooks::View.register_partial_view "meta_section", "comments"

Feather::Hooks::Menu.add_menu_item "Comments", "/admin/comments"