module Feather
  class Tags < Application
    include_plugin_views __FILE__

    def show(id)
      @tag = Tag.first(:conditions => {:name => id})
      display @tag
    end

    def index
      display @tags
    end
  end
end