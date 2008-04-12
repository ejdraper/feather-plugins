class Redirector < Application
  def show(id)
    @redirect = Redirect[id]
    [@redirect.permanent ? 301 : 302, redirect(@redirect.to_url), []]
  end
end