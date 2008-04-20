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

Hooks::Menu.add_menu_item "Tweets", "/admin/tweets"

Hooks::Events.register_event(:after_article_index) { TwitterSetting.current.rescan }
Hooks::Events.register_event(:after_article_show) { TwitterSetting.current.rescan }