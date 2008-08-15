require 'dm-tags'
require File.join(File.join(File.dirname(__FILE__), "controllers"), "tags")
require File.join(File.join(File.dirname(__FILE__), "models"), "article")

include Merb::Cache::ControllerInstanceMethods

Merb::Router.prepend do |r|
  r.match('/tags/:id').to(:controller => 'tags', :action =>'show').name(:tag)
end

Hooks::View.register_partial_view "article_form_fields", "tag_field"
Hooks::View.register_partial_view "meta_section", "tag_list"
#Hooks::View.register_partial_view "sidebar", "tag_cloud"

#Hooks::Events.register_event(:after_save_article) do |args|
#  args.first.create_tags
#  expire_all_pages
#end
