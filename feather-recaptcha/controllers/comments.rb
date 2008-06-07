gem 'recaptcha'
class Comments < Application
  include ReCaptcha::AppHelper
  before :plugin_recaptcha_handle, :only => [:create]
  
  private
    def plugin_recaptcha_handle
      if !validate_recap(params,[])
        throw :halt, Proc.new {|c| c.redirect Article[params[:comment]["article_id"]].permalink }
          #--> NOTE: this(redirect)'ll have to do for now...
      end
    end
end