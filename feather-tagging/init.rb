gem "dm-tags"
require 'dm-tags'
require File.join(File.dirname(__FILE__), "controllers", "tags")
require File.join(File.dirname(__FILE__), "lib", "global_helpers")

class LazyArray
  RETURN_SELF = []
end

Feather::Article.class_eval do
  include DataMapper::Tags
  has_tags
end

Feather::Hooks::Routing.register_route do |r|
  r.match('/tags').to(:controller => 'tags', :action => 'index').name(:tagindex)
  r.match('/tag/:id').to(:controller => 'tags', :action =>'show').name(:tag)
end

Feather::Hooks::View.register_partial_view "article_form_fields", "tag_field"
Feather::Hooks::View.register_partial_view "meta_section", "tag_list"
Feather::Hooks::View.register_partial_view "sidebar", "tag_cloud"
