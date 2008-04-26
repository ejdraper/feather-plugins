class Tags < Application
  include_plugin_views __FILE__

  def show(id)
    @tag = Tag.first(:permalink => id)
    display @tag
  end
end