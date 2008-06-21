class JabberSetting
  include DataMapper::Resource
  
  property :id, Integer, :key => true
  property :jabber_notification, Boolean, :nullable => false, :default => false
  property :from_jabber, String
  property :from_jabber_pass, String
  property :to_jabber, String
  
  ##
  # This returns the current settings, creating them if they aren't found
  def self.current
    jabber_settings = JabberSetting.first
    jabber_settings = JabberSetting.create(:jabber_notification => false) if jabber_settings.nil?
    jabber_settings
  end
  
end
