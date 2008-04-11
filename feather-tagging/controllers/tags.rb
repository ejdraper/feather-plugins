class Tags < Application
  # TODO: Make a base plugin controller that has this in it. 
  include_plugin_views __FILE__
  
  def show(id)
    @tag = Tag.first(:name => id)
    display @tag
  end
  
end