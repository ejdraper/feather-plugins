require "xmlrpc/client"
require File.join(File.dirname(__FILE__), "controllers", "admin", "ping_logs")
require File.join(File.dirname(__FILE__), "controllers", "admin", "ping_services")
require File.join(File.dirname(__FILE__), "models", "admin", "ping_log")
require File.join(File.dirname(__FILE__), "models", "admin", "ping_service")

Merb::Router.prepend do |r|
  r.namespace "feather/admin", :path => "admin", :name_prefix => "admin" do
    r.resources :ping_logs
    r.resources :ping_services
  end
end

Feather::Hooks::Menu.add_menu_item "Ping Services", "/admin/ping_services"

Feather::Hooks::Events.register_event(:after_publish_article_request) do |args|
  Feather::PingService.all.each do |ping|
    log = Feather::PingLog.new
    log.ping_service_id = ping.id
    begin
      log.message = ping.execute(args[0], args[1])
      log.successful = true
    rescue Exception => err
      log.message = err.message
      log.successful = false
    end
    log.save
  end
end