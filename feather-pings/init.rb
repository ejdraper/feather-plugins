require "xmlrpc/client"
require File.join(File.join(File.dirname(__FILE__), "controllers"), "ping_logs")
require File.join(File.join(File.dirname(__FILE__), "controllers"), "ping_services")
require File.join(File.join(File.dirname(__FILE__), "models"), "ping_log")
require File.join(File.join(File.dirname(__FILE__), "models"), "ping_service")

Merb::Router.prepend do |r|
  r.namespace :admin do |admin|
    admin.resources :ping_logs
    admin.resources :ping_services
  end
end

Hooks::Menu.add_menu_item "Ping Services", "/admin/ping_services"

Hooks::Events.register_event(:after_publish_article) do |args|
  PingService.all.each do |ping|
    log = PingLog.new
    log.ping_service_id = ping.id
    begin
      log.message = ping.execute(args.first)
      log.successful = true
    rescue Exception => err
      log.message = err.message
      log.successful = false
    end
    log.save
  end
end