class Comment < DataMapper::Base
  before_save :validate_with_akismet
  
  private
    def validate_with_akismet
      akismet = Akismet.new(AkismetConfig.current.api_key, AkismetConfig.current.url)
      
      options = { :user_ip              => self.ip_address, 
                  :user_agent           => user_agent, 
                  :referrer             => referrer,
                  :permalink            => "http://#{request.host_with_port}#{site.permalink_for(self)}", 
                  :comment_author       => self.name, 
                  :comment_author_email => self.email_address, 
                  :comment_author_url   => self.website, 
                  :comment_content      => self.comment}
      
      self.published = !akismet.comment_check(options)
    end
end