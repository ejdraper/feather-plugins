require "net/http"
require "hpricot"
require "uri"
require File.join(File.dirname(__FILE__), "controllers", "admin", "importer")
require File.join(File.dirname(__FILE__), "controllers", "admin", "mephisto")
require File.join(File.dirname(__FILE__), "controllers", "admin", "type")
require File.join(File.dirname(__FILE__), "models", "feather", "article")
require File.join(File.dirname(__FILE__), "models", "feather", "assigned_section")
require File.join(File.dirname(__FILE__), "models", "feather", "comment")
require File.join(File.dirname(__FILE__), "models", "feather", "section")
require File.join(File.dirname(__FILE__), "models", "feather", "tag")
require File.join(File.dirname(__FILE__), "models", "feather", "tagging")
require File.join(File.dirname(__FILE__), "models", "feather", "typo_article")
require File.join(File.dirname(__FILE__), "models", "feather", "typo_assigned_section")
require File.join(File.dirname(__FILE__), "models", "feather", "typo_base")
require File.join(File.dirname(__FILE__), "models", "feather", "typo_comment")
require File.join(File.dirname(__FILE__), "models", "feather", "typo_section")
require File.join(File.dirname(__FILE__), "models", "feather", "typo_tag")
require File.join(File.dirname(__FILE__), "models", "feather", "typo_tagging")

Merb::Router.prepend do |r|
  r.namespace "feather/admin", :path => "admin", :name_prefix => "admin" do
    r.resource :importer
    r.resource :mephisto
    r.resource :typo
  end
end

Feather::Hooks::Menu.add_menu_item "Importer", "/admin/importer"