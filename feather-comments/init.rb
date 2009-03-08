$:.unshift(File.join(File.dirname(__FILE__), "vendor", "splam", "lib"))
require 'splam'
require 'splam/rule'
require 'splam/rules'

require File.join(File.dirname(__FILE__), "controllers", "admin", "comments")
require File.join(File.dirname(__FILE__), "controllers", "comments")
require File.join(File.dirname(__FILE__), "models", "feather", "comment")

Feather::Hooks::Routing.register_route do |r|
  r.resources :comments, :controller => "comments"
  r.namespace "feather/admin", :path => "admin", :name_prefix => "admin" do
    r.resources :comments, :path => "admin/comments", :name_prefix => "admin", :controller => "admin/comments"
  end
end

Feather::Hooks::View.register_partial_view "after_article", "comments"
Feather::Hooks::View.register_partial_view "meta_section", "comments"

Feather::Hooks::Menu.add_menu_item "Comments", "/admin/comments"