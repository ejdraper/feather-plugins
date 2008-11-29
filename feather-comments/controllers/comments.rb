module Feather
  class Comments < Application  
    def create
      if (!CommentSetting.current.negative_captcha || params[:comment][:notes].nil? || params[:comment][:notes] == "")
        @comment = Comment.new(params[:comment])
        @comment.ip_address = request.remote_ip
        @comment.published = !CommentSetting.current.moderation
        if !@comment.save
          session[:comment_error] = @comment.errors.collect { |e| e[1].first }
        else
          article = Article[@comment.article_id]
          # Send e-mail notification if that setting is enabled
          if CommentSetting.current.email_notification
            email_params = { :from => CommentSetting.current.from_email, :to => CommentSetting.current.to_email, :subject => "New comment - RE: #{article.title}" }
            params = { :comment => @comment, :article => article, :request => request }
            send_mail(CommentMailer, :notify, email_params, params)
          end
          redirect article.permalink
        end
      end
      redirect request.env["HTTP_REFERER"]
    end
  end
end