require 'xmlrpc/client'
require 'openssl'
require 'base64'

# Mollom API requires this to change, but this gives a warning!
# XMLRPC::Client::USER_AGENT = "Ruby Mollom/0.1"

class Mollom
  API_VERSION = '1.0'
  module Errors
    Standard = 1000
    Refresh = 1100
    Redirect = 1200
  end

  attr_accessor :private_key, :public_key
  attr_writer :server_list

  # Creates a new Mollom object. Takes +private_key+ and +public_key+ as keys.
  # 
  #   Mollom.new(:private_key => 'qopzalnzanzajlazjna', :public_key => 'aksakzaddazidzaodjaz')
  #   # => #<Mollom:0x5b6454 @public_key="aksakzaddazidzaodjaz", @private_key="qopzalnzanzajlazjna">
  
  def initialize options = {}
    @private_key = options[:private_key]
    @public_key = options[:public_key]
  end

  # Checks the content whether it is spam, ham (not spam), or undecided, and gives a quality assessment of the content.
  # Possible content keys are:
  #  session_id     # => If you allready have a session_id
  #  post_title     # => The title
  #  post_body      # => The main content of the post.
  #  author_name    # => The name of the post author
  #  author_url     # => The url the author enters
  #  author_mail    # => The author's email address
  #  author_ip      # => The author's IP address
  #  author_openid  # => The author's OpenID
  #  author_id      # => The author's ID
  #
  # Only the +post_body+ key is required, all other keys are optional.
  # This function returns a ContentResponse object.
  #
  #  response = mollom.check_content :post_title => 'Mollom rules!', 
  #                                  :post_body => 'I think that mollom is so cool!', 
  #                                  :author_name => 'Jan De Poorter', 
  #                                  :author_url => 'http://www.openminds.be'
  #  response.spam? # => false
  #  response.ham?  # => true
  def check_content content = {}
    return ContentResponse.new(send_command('mollom.checkContent', content))
  end

  # Requests an Image captcha from Mollom. It takes the optional <tt>session_id</tt> and <tt>author_ip</tt> keys, if you allready have a session.
  # It returns a hash with the URL where the captcha can be found, and the session_id, to keep track of the current session (Needed later in <tt>Mollom#check_captcha</tt>)
  #
  #  captcha = mollom.image_captcha :author_ip => '172.16.0.1'
  #  captcha['url']        # => http://xmlrpc1.mollom.com:80/a9616e6b4cd6a81ecdd509fa624d895d.png
  #  captcha['session_id'] # => a9616e6b4cd6a81ecdd509fa624d895d
  def image_captcha info = {}
    return send_command('mollom.getImageCaptcha', info)
  end

  # Requests an Audio captcha from Mollom. It takes the optional +session_id+ and +author_ip+ keys, if you allready have a session.
  # It returns a hash with the URL where the captcha can be found, and the session_id, to keep track of the current session (Needed later in <tt>Mollom#check_captcha</tt>)
  #
  #  captcha = mollom.audio_captcha :author_ip => '172.16.0.2', :session_id => 'a9616e6b4cd6a81ecdd509fa624d895d'
  #  captcha['url']        # => http://xmlrpc1.mollom.com:80/a9616e6b4cd6a81ecdd509fa624d895d.mp3
  #  captcha['session_id'] # => a9616e6b4cd6a81ecdd509fa624d895d
  def audio_captcha info = {}
    return send_command('mollom.getAudioCaptcha', info)
  end

  # Checks with mollom if the given captcha (by the user) is correct. Takes +session_id+ and +solution+ keys. Both keys are required.
  # Returns true if the captcha is valid, false if it is incorrect
  #
  #  captcha = mollom.image_captcha :author_ip => '172.16.0.1'
  #  # show to user... input from user
  #  return = mollom.valid_captcha? :session_id => captcha['session_id'], :solution => 'abcDe9'
  #  return # => true
  def valid_captcha? info = {}
    return send_command('mollom.checkCaptcha', info)
  end

  # Standard check to see if your public/private keypair are recognized. Takes no options
  def key_ok?
    return send_command('mollom.verifyKey')
  end

  # Gets some statistics from Mollom about your site.
  #
  # The type has to be passed. Possible types:
  #  total_days
  #  total_accepted
  #  total_rejected
  #  yesterday_accepted
  #  yesterday_rejected
  #  today_accepted
  #  today_rejected
  #
  #  mollom.statistics :type => 'total_accepted' # => 123
  def statistics options = {}
    return send_command('mollom.getStatistics', options)
  end

  # Send feedback to Mollom about a certain content. Required keys are +session_id+ and +feedback+. 
  # 
  # Feedback can be any of
  #  spam
  #  profanity
  #  low-quality
  #  unwanted
  #
  #  mollom.send_feedback :session_id => 'a9616e6b4cd6a81ecdd509fa624d895d', :feedback => 'unwanted'
  def send_feedback feedback = {}
    return send_command('mollom.sendFeedback', feedback)
  end

  # Gets a list of servers from Mollom. You should cache this information in your application in a temporary file or in a database. You can set this with Mollom#server_list=
  # 
  # Takes an optional parameter +refresh+, which resets the cached value.
  #
  #  mollom.server_list
  #  # => [{:proto=>"http", :ip=>"88.151.243.81"}, {:proto=>"http", :ip=>"82.103.131.136"}]
  def server_list refresh = false
    @server_list = nil if refresh
    @server_list ||= XMLRPC::Client.new("xmlrpc.mollom.com", "/#{API_VERSION}").call('mollom.getServerList', authentication_hash).collect do |server| 
      proto, ip = server.split('://')
      {:proto => proto, :ip => ip}
    end
  end

  private
  def send_command(command, data = {})
    server_list.each do |server|
      begin
        return XMLRPC::Client.new(server[:ip], "/#{API_VERSION}").call(command, data.merge(authentication_hash))
      # TODO: Rescue more stuff (Connection Timeout and such)
      rescue XMLRPC::FaultException => error
        case error.faultCode
        when Errors::Standard
          raise Error.new(error.faultString)
        when Errors::Refresh
          # we take this one out of our loop
          raise
        when Errors::Redirect
          next
        else
          next
        end
      end
    end
    raise Mollom::NoAvailableServers
  rescue XMLRPC::FaultException
    # We know it is Errors::Refresh
    server_list(true)
    retry
  end
  
  # Creates a HMAC-SHA1 Hash with the current timestamp, a nonce, and your private key.
  def authentication_hash
    now = Time.now.gmtime.strftime('%Y-%m-%dT%H:%M:%S.000+0000')
    nonce = Kernel.rand(2**31) # Random signed int

    hash = Base64.encode64(
      OpenSSL::HMAC.digest(OpenSSL::Digest::SHA1.new, @private_key, "#{now}:#{nonce}:#{@private_key}")
    ).chomp

    return :public_key=> @public_key, :time => now, :hash => hash, :nonce => nonce
  end

  class ContentResponse
    attr_reader :session_id, :quality

    Unknown = 0
    Ham  = 1
    Unsure = 2
    Spam = 3

    # This class should only be initialized from within the +check_content+ command.
    def initialize(hash)
      @spam_response = hash["spam"]
      @session_id = hash["session_id"]
      @quality = hash["quality"]
    end

    # Is the content Spam?
    def spam?
      @spam_response == Spam
    end

    # Is the content Ham?
    def ham?
      @spam_response == Ham
    end

    # is Mollom unsure about the content?
    def unsure?
      @spam_response == Unsure
    end

    # is the content unknown?
    def unknown?
      @spam_response == Unknown
    end
    
    # Returns 'unknown', 'ham', 'unsure' or 'spam', depending on what the content is.
    def to_s
      case @spam_response
      when Unknown: 'unknown'
      when Ham: 'ham'
      when Unsure: 'unsure'
      when Spam: 'spam'
      end
    end
  end
  
  class Error < StandardError; end
  class NoAvailableServers < Error; end
end