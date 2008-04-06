module Admin
  class Links < Base
    include_plugin_views __FILE__

    def index
      render
    end
  end
end