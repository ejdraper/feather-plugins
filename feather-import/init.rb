require "net/http"
require "hpricot"
require "uri"
require File.join(File.join(File.dirname(__FILE__), "controllers"), "importer")

Merb::Router.prepend do |r|
  r.namespace :admin do |admin|
    admin.resource :importer
  end
end

Hooks::Menu.add_menu_item "Importer", "/admin/importer"