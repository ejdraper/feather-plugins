module Feather
  class Comments < Application  
    def create
      if params[:comment][:title].blank?
        @comment = Comment.new(params[:comment])
        @comment.ip_address = request.remote_ip
        @comment.save
        @article = Article[@comment.article_id]
      end
      redirect @article.nil? ? request.env["HTTP_REFERER"] : (!::Feather.config[:path_prefix].empty? ? "/#{::Feather.config[:path_prefix]}#{@article.permalink}" : @article.permalink)
    end
  end
end