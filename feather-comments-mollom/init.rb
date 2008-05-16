MOLLOM_PRIVATE_KEY = "f2aec2fbe918e02f5fc5091074674933"
MOLLOM_PUBLIC_KEY = "fa73268310d828e43d6ea3a8829cc5ea"

require File.join(File.join(File.join(File.dirname(__FILE__), "controllers"), "admin"), "comments")
require File.join(File.join(File.join(File.dirname(__FILE__), "controllers"), "admin"), "comment_settings")
require File.join(File.join(File.dirname(__FILE__), "controllers"), "comments")
require File.join(File.join(File.dirname(__FILE__), "mailers"), "comment_mailer")
require File.join(File.join(File.dirname(__FILE__), "models"), "comment")
require File.join(File.join(File.dirname(__FILE__), "models"), "comment_setting")

Merb::Router.prepend do |r|
  r.resources :comments
  r.namespace :admin do |admin|
    admin.resources :comments
    admin.resource :comment_settings
  end
end

Hooks::View.register_partial_view "after_article", "comments"
Hooks::View.register_partial_view "meta_section", "comments"

Hooks::Menu.add_menu_item "Comments", "/admin/comments"