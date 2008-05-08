require File.join(File.join(File.dirname(__FILE__), "controllers"), "typo")
require File.join(File.join(File.dirname(__FILE__), "models"), "typo_base")
require File.join(File.join(File.dirname(__FILE__), "models"), "typo_article")
require File.join(File.join(File.dirname(__FILE__), "models"), "typo_assigned_section")
require File.join(File.join(File.dirname(__FILE__), "models"), "typo_comment")
require File.join(File.join(File.dirname(__FILE__), "models"), "typo_section")
require File.join(File.join(File.dirname(__FILE__), "models"), "typo_tag")
require File.join(File.join(File.dirname(__FILE__), "models"), "typo_tagging")

Merb::Router.prepend do |r|
  r.namespace :admin do |admin|
    admin.resource :typo
  end
end

Hooks::Menu.add_menu_item "Typo", "/admin/typo"