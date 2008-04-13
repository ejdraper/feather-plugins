require File.join(File.join(File.dirname(__FILE__), "controllers"), "tags")
require File.join(File.join(File.dirname(__FILE__), "models"), "tag")
require File.join(File.join(File.dirname(__FILE__), "models"), "tagging")

# This reopens the article class, and adds a bunch of tagging support code.
require File.join(File.join(File.dirname(__FILE__), "lib"), "article")
# This reopens the global_helpers module, and adds the tag cloud stuff.
require File.join(File.join(File.dirname(__FILE__), "lib"), "global_helpers")

Merb::Router.prepend do |r|
  r.match('/tags/:id').to(:controller => 'tags', :action =>'show').name(:tag)
end

Hooks::Events.register_event(:after_save_article) do |args|
  args.first.create_tags
end

Hooks::View.register_partial_view "article_form_fields", "tag_field"
Hooks::View.register_partial_view "meta_section", "tag_list"
Hooks::View.register_partial_view "sidebar", "tag_cloud"