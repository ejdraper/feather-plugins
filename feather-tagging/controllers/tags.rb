module Feather
  class Tags < Application
    include_plugin_views __FILE__

    def show(id)
      @tag = Feather::Tag.get!(id)
     display @tag
    end

    def index
      @tags = Feather::Tag.all
      display @tags
    end
  end
end