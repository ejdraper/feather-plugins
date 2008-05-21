begin
  jabber_settings = JabberSetting.first
rescue
  jabber_settings = nil
end
Database::migrate(JabberSetting)
unless jabber_settings.nil?
  jabber_settings.instance_variable_set("@new_record", true)
  jabber_settings.save
end