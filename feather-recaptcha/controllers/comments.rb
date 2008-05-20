gem 'recaptcha'
class Comments < Application
  include ReCaptcha::AppHelper
  before :validate_recaptcha, :only => [:create]
  
  private
    def validate_recaptcha()
      validate_recap(params,[])
    end
end