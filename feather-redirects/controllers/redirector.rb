module Feather
  class Redirector < Application
    def show(id)
      @redirect = Feather::Redirect[id]
      self.status = @redirect.permanent ? 301 : 302
      redirect(@redirect.to_url)
    end
  end
end