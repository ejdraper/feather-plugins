class PingService < DataMapper::Base
  property :name, :string, :nullable => false
  property :url, :string, :nullable => false, :length => 255
  property :extended, :boolean

  validates_presence_of :name, :key => "uniq_ping_service_name"
  validates_presence_of :url, :key => "uniq_ping_service_url"

  ##
  # This executes the specific ping for the specified article
  def execute(article, request)
    if self.extended
      extended_ping(article, request)
    else
      standard_ping(article, request)
    end
  end

  private
    ##
    # This performs a standard ping for the specified article, and returns the result
    def standard_ping(article, request)
      # Make the RPC call
      res = XMLRPC::Client.new2(self.url).call("weblogUpdates.ping", article.title, "http://#{request.env['HTTP_HOST']}#{article.permalink}")
      # Raise any errors found
      raise res["message"] if res["error"] == true || res["flerror"] == true
      # Return the result
      res["message"]
    end

    ##
    # This performs an extended ping for the specified article, and returns the result
    def extended_ping(article, request)
      # Grab the feed url, but only if the plugin is installed and active, otherwise send nil through
      feed_url = is_plugin_active("feather-feeds") ? "http://#{request.env['HTTP_HOST']}/articles.rss" : nil
      # Make the RPC call
      res = XMLRPC::Client.new2(self.url).call("weblogUpdates.extendedPing", article.title, "http://#{request.env['HTTP_HOST']}#{article.permalink}", feed_url)
      # Raise any errors found
      raise res["message"] if res["error"] == true || res["flerror"] == true
      # Return the result
      res["message"]
    end
end