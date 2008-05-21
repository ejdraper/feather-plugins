class JabberSetting < DataMapper::Base
  property :jabber_notification, :boolean, :nullable => false, :default => false
  property :from_jabber, :string
  property :from_jabber_pass, :string
  property :to_jabber, :string
  
  ##
  # This returns the current settings, creating them if they aren't found
  def self.current
    jabber_settings = JabberSetting.first
    jabber_settings = JabberSetting.create(:jabber_notification => false) if jabber_settings.nil?
    jabber_settings
  end
  
end
