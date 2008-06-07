PluginDependencies::register_dependency "feather-comments"
require File.join(File.join(File.dirname(__FILE__), "helpers"), "global_helpers")
require File.join(File.join(File.dirname(__FILE__), "controllers"), "comments")
require File.join(File.join(File.join(File.dirname(__FILE__), "controllers"), "admin"), "recaptcha_configuration")
require File.join(File.join(File.dirname(__FILE__), "models"), "recaptcha_config")

Database::migrate(RecaptchaConfig) unless database.table_exists?(RecaptchaConfig)

RCC_PUB = RecaptchaConfig.current.public_key
RCC_PRIV = RecaptchaConfig.current.private_key

gem "recaptcha"
require "recaptcha"

Merb::Router.prepend do |r|
  r.namespace :admin do |admin|
    admin.resource :recaptcha_configuration
  end
end

Hooks::Menu.add_menu_item "Recaptcha", "/admin/recaptcha_configuration"
Hooks::View.register_partial_view "after_article", "recaptcha"