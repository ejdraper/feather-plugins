require File.join(File.join(File.dirname(__FILE__), "controllers"), "mephisto")
require File.join(File.join(File.dirname(__FILE__), "models"), "article")
require File.join(File.join(File.dirname(__FILE__), "models"), "assigned_section")
require File.join(File.join(File.dirname(__FILE__), "models"), "comment")
require File.join(File.join(File.dirname(__FILE__), "models"), "section")
require File.join(File.join(File.dirname(__FILE__), "models"), "tag")
require File.join(File.join(File.dirname(__FILE__), "models"), "tagging")

Merb::Router.prepend do |r|
  r.namespace :admin do |admin|
    admin.resource :mephisto
  end
end

Hooks::Menu.add_menu_item "Mephisto", "/admin/mephisto"
