require File.join(File.join(File.dirname(__FILE__), "controllers"), "redirector")
require File.join(File.join(File.dirname(__FILE__), "controllers"), "redirects")
require File.join(File.join(File.dirname(__FILE__), "models"), "redirect")

Merb::Router.prepend do |r|
  # This deferred route allows redirects to be handled
  r.match("").defer_to do |request, path_match|
    unless (redirect = Redirect.find_by_from_url(request.uri.to_s.chomp("/"))).nil?
      {:controller => "redirector", :action => "show", :id => redirect.id}
    end
  end

  r.namespace :admin do |admin|
    admin.resources :redirects
  end
end

Hooks::Menu.add_menu_item "Redirects", "/admin/redirects"