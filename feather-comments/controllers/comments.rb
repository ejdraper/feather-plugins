class Comments < Application  
  def create
    if (!CommentSetting.current.negative_captcha || params[:comment][:notes].nil? || params[:comment][:notes] == "")
      @comment = Comment.new(params[:comment])
      @comment.ip_address = request.env["REMOTE_HOST"]
      @comment.published = !CommentSetting.current.moderation
      session[:comment_error] = @comment.errors if !@comment.save
      article = Article[@comment.article_id]
      expire_index
      expire_article(article)
      
      send_mail(CommentMailer, :notify, {:from => "", :to => "", :subject => ""}, {:comment => @comment})
    end
    redirect article.permalink
  end
end