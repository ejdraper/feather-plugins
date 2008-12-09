require File.join(File.dirname(__FILE__), "controllers", "redirector")
require File.join(File.dirname(__FILE__), "controllers", "admin", "redirects")
require File.join(File.dirname(__FILE__), "models", "feather", "redirect")

Feather::Hooks::Routing.register_route do |r|
  # This deferred route allows redirects to be handled
  r.match("").defer_to do |request, path_match|
    unless (redirect = Feather::Redirect.find_by_from_url(request.uri.to_s.chomp("/"))).nil?
      {:controller => "feather/redirector", :action => "show", :id => redirect.id}
    end
  end

  r.namespace "feather/admin", :path => "admin", :name_prefix => "admin" do
    r.resources :redirects
  end
end

Feather::Hooks::Menu.add_menu_item "Redirects", "/admin/redirects"