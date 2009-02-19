module Feather
  class Tags < Application
    include_plugin_views __FILE__

    def show(id)
      @tag = Tag.get(id)
      @tag = Tag.first(:conditions => {:name => CGI.unescape(id)}) if @tag.nil?
      display @tag
    end

    def index
      display @tags
    end
  end
end