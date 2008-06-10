class Comment
  attr_accessor :mollom_content
  before :save, :check_if_spam
    
  def self.mollom
    @@mollom ||= Mollom.new(:private_key => MollomConfig.current.private_key, :public_key => MollomConfig.current.public_key)
  end

  def self.mollom=(value)
    @@mollom = value
  end

  def spam?
    return false if self.comment.nil? || self.comment.empty?
    options = {}
    options[:post_body] = self.comment if self.comment
    options[:author_name] = self.name if self.name
    options[:author_url] = self.website if self.website
    options[:author_ip] = self.ip_address if self.ip_address
    self.mollom_content ||= Comment.mollom.check_content( options)
    self.mollom_content.spam?
  end
  
  def check_if_spam
    self.published = false if self.spam?
  end
  
end