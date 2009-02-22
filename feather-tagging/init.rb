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
  
  after :save, :update_tags
  after :destroy, :update_tags
  
  def update_tags
    Merb::Cache[:feather].delete "#{Tag.name}"
    Merb::Cache[:feather].delete "#{Tagging.name}"
  end
end

Feather::Application.class_eval do
  before :grab_tags
  
  def grab_tags
    @tags = Merb::Cache[:feather].fetch "#{Tag.name}" do
      Tag.all.collect { |t| t.attributes.merge(:display_name => t.display_name) }
    end
    @taggings = Merb::Cache[:feather].fetch "#{Tagging.name}" do
      Tagging.all.collect { |t| t.attributes }
    end
  end
end

Tag.class_eval do
  before :save, :no_spaces
  def no_spaces
    self.name.gsub!(" ", "-")
  end
  
  def display_name
    self.name.gsub("-", " ")
  end
end

Feather::Hooks::Routing.register_route do |r|
  r.match('/tags').to(:controller => 'tags', :action => 'index').name(:tagindex)
  r.match('/tag/:id').to(:controller => 'tags', :action =>'show').name(:tag)
end

Feather::Hooks::View.register_partial_view "article_form_fields", "tag_field"
Feather::Hooks::View.register_partial_view "meta_section", "tag_list"
Feather::Hooks::View.register_partial_view "sidebar", "tag_cloud"
