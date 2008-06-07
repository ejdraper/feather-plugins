require "recaptcha"
include ReCaptcha::ViewHelper

# rails baggage to carry for now, cos we're ultimate using a rails plugin really ('recaptcha')
def session
  @dummy = @dummy? @dummy : {}
end
class Array
  def add_to_base(msg)
    # not choosing to do anything with this 'msg' right now...
  end
end

module Merb
  module GlobalHelpers
    def feather_gen_recaptcha(options) 
      get_captcha(options)
    end 
  end
end