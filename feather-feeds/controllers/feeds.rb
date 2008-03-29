class Feeds < Application
  def rss
    @articles = Article.all(:limit => 15, :order => "published_at DESC")
    #TODO: render RSS
  end
  
  def atom
    @articles = Article.all(:limit => 15, :order => "published_at DESC")
    #TODO: render ATOM
  end
end