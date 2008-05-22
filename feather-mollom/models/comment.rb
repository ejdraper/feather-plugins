class Comment < DataMapper::Base
  attr_accessor :mollom_content
  before_save :check_if_spam
    
  def self.mollom
    @@mollom ||= Mollom.new(:private_key => MollomConfig.current.private_key, :public_key => MollomConfig.current.public_key)
  end

  def self.mollom=(value)
    @@mollom = value
  end

  def spam?
    return false if self.comment.nil? || self.comment.empty?
    self.mollom_content ||= Comment.mollom.check_content( :post_body => self.comment,
                                                          :author_name => self.name,
                                                          :author_url => self.website)
    self.mollom_content.spam?
  end
  
  def check_if_spam
    self.published = false if self.spam?
  end
  
end