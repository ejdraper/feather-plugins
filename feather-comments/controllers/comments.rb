class Comments < Application  
  def create
    @comment = Comment.new(params[:comment])
    session[:comment_error] = @comment.errors if !@comment.save
    redirect Article[@comment.post_id].permalink
  end
end