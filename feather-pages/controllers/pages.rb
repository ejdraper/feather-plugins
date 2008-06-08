class Pages < Application
  include_plugin_views __FILE__
  cache_pages :show

  def show(id)
    @page = Page.first(:permalink => id, :published => true) || Page.get(id)
    raise NotFound unless @page
    display @page
  end

end