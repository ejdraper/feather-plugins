require "recaptcha"
module Merb
  module GlobalHelpers
    def get_captcha(options) 
      ReCaptcha::ViewHelper.get_captcha(options)
    end 
  end
end