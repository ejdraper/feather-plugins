module Feather
  class Comments < Application  
    def create
      if params[:comment][:title].blank?
        @comment = Comment.new(params[:comment])
        @comment.ip_address = request.remote_ip
        @comment.save
        @article = Article[@comment.article_id]
      end
      redirect @article.nil? ? request.env["HTTP_REFERER"] : @article.permalink
    end
  end
end