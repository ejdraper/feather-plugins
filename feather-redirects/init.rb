require File.join(File.dirname(__FILE__), "controllers", "redirector")
require File.join(File.dirname(__FILE__), "controllers", "admin", "redirects")
require File.join(File.dirname(__FILE__), "models", "feather", "redirect")

Feather::Hooks::Routing.register_route do |r|
  # This deferred route allows redirects to be handled
  r.match("/:controller", :controller => '.*').defer_to do |request, params|
    unless (redirect = Feather::Redirect.find_by_from_url(request.uri.to_s.chomp("/"))).nil?
      params.merge!({:controller => "redirector", :action => "show", :id => redirect.id})
    end
  end  

  r.namespace "admin", :path => "admin", :name_prefix => "admin" do
    r.resources :redirects, :path => "admin/redirects", :name_prefix => "admin", :controller => "admin/redirects"
  end
end

Feather::Hooks::Menu.add_menu_item "Redirects", "/admin/redirects"