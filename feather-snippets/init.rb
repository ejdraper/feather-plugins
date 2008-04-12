require File.join(File.join(File.dirname(__FILE__), "controllers"), "snippets")
require File.join(File.join(File.dirname(__FILE__), "models"), "snippet")

Merb::Router.prepend do |r|
  r.namespace :admin do |admin|
    admin.resources :snippets
  end
end

Hooks::Menu.add_menu_item do
  {:text => "Snippets", :url => "/admin/snippets" }
end

##
# Re-opening the main controller just to register any snippets as required
class Application < Merb::Controller
  before :load_snippets

  ##
  # This loads any snippets that aren't yet registered (for example, that were created on another application process thread)
  def load_snippets
    Snippet.all.each do |snippet|
      snippet.register unless snippet.registered?
    end
  end
end