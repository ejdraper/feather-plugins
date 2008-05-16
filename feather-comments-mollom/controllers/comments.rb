class Comments < Application  
  def create
    if (!CommentSetting.current.negative_captcha || params[:comment][:notes].nil? || params[:comment][:notes] == "")
      @comment = Comment.new(params[:comment])
      @comment.ip_address = request.env["REMOTE_HOST"]
      @comment.published = !(CommentSetting.current.moderation || @comment.spam?)
      session[:comment_error] = @comment.errors if !@comment.save
      article = Article[@comment.article_id]
      # Expire the main article index, and the article page itself
      expire_index
      expire_article(article)
      # Send e-mail notification if that setting is enabled
      if CommentSetting.current.email_notification
        email_params = { :from => CommentSetting.current.from_email, :to => CommentSetting.current.to_email, :subject => "New comment - RE: #{article.title}" }
        params = { :comment => @comment, :article => article, :request => request }
        send_mail(CommentMailer, :notify, email_params, params)
      end
    end
    redirect article.permalink
  end
end