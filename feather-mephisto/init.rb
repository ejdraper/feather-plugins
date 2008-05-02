require File.join(File.join(File.dirname(__FILE__), "controllers"), "mephisto")
require File.join(File.join(File.dirname(__FILE__), "models"), "mephisto_article")
require File.join(File.join(File.dirname(__FILE__), "models"), "mephisto_assigned_section")
require File.join(File.join(File.dirname(__FILE__), "models"), "mephisto_base")
require File.join(File.join(File.dirname(__FILE__), "models"), "mephisto_comment")
require File.join(File.join(File.dirname(__FILE__), "models"), "mephisto_section")
require File.join(File.join(File.dirname(__FILE__), "models"), "mephisto_tag")
require File.join(File.join(File.dirname(__FILE__), "models"), "mephisto_tagging")

Merb::Router.prepend do |r|
  r.namespace :admin do |admin|
    admin.resource :mephisto
  end
end

Hooks::Menu.add_menu_item "Mephisto", "/admin/mephisto"