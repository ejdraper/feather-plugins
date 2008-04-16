class CommentSetting < DataMapper::Base
  property :moderation, :boolean, :default => false
  property :negative_captcha, :boolean, :default => false
  property :email_notification, :boolean, :default => false
  
  ##
  # This returns the current settings, creating them if they aren't found
  def self.current
    comment_settings = CommentSetting.first
    comment_settings = CommentSetting.create(:moderation => false, :negative_captcha => false, :email_notification => false) if comment_settings.nil?
    comment_settings
  end
end