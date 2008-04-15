class Comments < Application  
  def create
    @comment = Comment.new(params[:comment])
    session[:comment_error] = @comment.errors if !@comment.save
    article = Article[@comment.article_id]
    expire_index
    expire_article(article)
    redirect article.permalink
  end
end