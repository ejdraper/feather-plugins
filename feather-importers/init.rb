require "net/http"
require "hpricot"
require "uri"
require File.join(File.dirname(__FILE__), "controllers", "admin", "importers")
require File.join(File.dirname(__FILE__), "controllers", "admin", "mephistos")
require File.join(File.dirname(__FILE__), "controllers", "admin", "typos")
require File.join(File.dirname(__FILE__), "models", "feather", "mephisto_article")
require File.join(File.dirname(__FILE__), "models", "feather", "mephisto_assigned_section")
require File.join(File.dirname(__FILE__), "models", "feather", "mephisto_comment")
require File.join(File.dirname(__FILE__), "models", "feather", "mephisto_section")
require File.join(File.dirname(__FILE__), "models", "feather", "mephisto_tag")
require File.join(File.dirname(__FILE__), "models", "feather", "mephisto_tagging")
require File.join(File.dirname(__FILE__), "models", "feather", "typo_base")
require File.join(File.dirname(__FILE__), "models", "feather", "typo_article")
require File.join(File.dirname(__FILE__), "models", "feather", "typo_assigned_section")
require File.join(File.dirname(__FILE__), "models", "feather", "typo_comment")
require File.join(File.dirname(__FILE__), "models", "feather", "typo_section")
require File.join(File.dirname(__FILE__), "models", "feather", "typo_tag")
require File.join(File.dirname(__FILE__), "models", "feather", "typo_tagging")

Feather::Hooks::Routing.register_route do |r|
  r.namespace "feather/admin", :path => "admin", :name_prefix => "admin" do
    r.resource :importer
    r.resource :mephisto
    r.resource :typo
  end
end

Feather::Hooks::Menu.add_menu_item "Importers", "/admin/importer"