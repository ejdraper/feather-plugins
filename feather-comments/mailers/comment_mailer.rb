module Feather
  class CommentMailer < Merb::MailController
    self._template_roots << [File.join(File.dirname(__FILE__), "views"), :_template_location]
  
    def notify
      @comment = params[:comment]
      @article = params[:article]
      @request = params[:request]
      render_mail
    end
  end
end