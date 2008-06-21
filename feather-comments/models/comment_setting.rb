class CommentSetting
  include DataMapper::Resource
  
  property :id, Integer, :key => true
  property :moderation, Boolean, :nullable => false, :default => false
  property :negative_captcha, Boolean, :nullable => false, :default => false
  property :email_notification, Boolean, :nullable => false, :default => false
  property :from_email, String
  property :to_email, String
  
  ##
  # This returns the current settings, creating them if they aren't found
  def self.current
    comment_settings = CommentSetting.first
    comment_settings = CommentSetting.create(:moderation => false, :negative_captcha => false, :email_notification => false) if comment_settings.nil?
    comment_settings
  end
end