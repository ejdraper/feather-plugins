class Search < Application
  include_plugin_views __FILE__
  
  def articles(query)
    @results = []
    @empty_query = (query.nil? || query.strip.empty?)
    @results = Article.all(:conditions => ["content like '%#{query}%' OR title like '%#{query}%'"], :order => [:created_at.desc]) unless @empty_query
    render :layout => :empty
  end
  
end