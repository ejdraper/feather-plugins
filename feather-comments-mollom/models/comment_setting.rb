class CommentSetting < DataMapper::Base
  property :moderation, :boolean, :nullable => false, :default => false
  property :negative_captcha, :boolean, :nullable => false, :default => false
  property :email_notification, :boolean, :nullable => false, :default => false
  property :from_email, :string
  property :to_email, :string
  
  ##
  # This returns the current settings, creating them if they aren't found
  def self.current
    comment_settings = CommentSetting.first
    comment_settings = CommentSetting.create(:moderation => false, :negative_captcha => false, :email_notification => false) if comment_settings.nil?
    comment_settings
  end
end