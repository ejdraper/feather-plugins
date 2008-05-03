require "net/http"
require "hpricot"
require "uri"
require File.join(File.join(File.join(File.dirname(__FILE__), "controllers"), "admin"), "tweets")
require File.join(File.join(File.join(File.dirname(__FILE__), "controllers"), "admin"), "twitter_settings")
require File.join(File.join(File.dirname(__FILE__), "models"), "tweet")
require File.join(File.join(File.dirname(__FILE__), "models"), "twitter_setting")

Merb::Router.prepend do |r|
  r.namespace :admin do |admin|
    admin.resources :tweets
    admin.resource :twitter_settings
  end
end

Hooks::View.register_partial_view "between_articles", "tweets"
Hooks::View.register_partial_view "first_article_in_list", "tweets"
Hooks::View.register_partial_view "last_article_in_list", "tweets"

Hooks::Menu.add_menu_item "Tweets", "/admin/tweets"

Hooks::Events.register_event(:after_article_index_request) { TwitterSetting.current.rescan }
Hooks::Events.register_event(:after_article_show_request) { TwitterSetting.current.rescan }