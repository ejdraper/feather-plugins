# Let's reopen the comment model to trap after_create and have that there instead of in the controller. Not that
# We can access the controller create method from here anyway, but imo this is cleaner regardless. - ML.
class Comment < DataMapper::Base

  after_create :send_to_jabber
  
  def send_to_jabber
    # Send Jabber notification if that setting is enabled
    if JabberSetting.current.jabber_notification
      from = JabberSetting.current.from_jabber
      pass = JabberSetting.current.from_jabber_pass
      to = JabberSetting.current.to_jabber
      subject = "New comment - RE: #{self.article.title}"
      body = "A new comment was posted to #{self.article.title} at your Blog by " + self.name + ":\n\"" + self.comment + "\""
      jid = JID::new(from)
      cl = Client::new(jid)
      cl.connect
      cl.auth(pass)
      m = Message::new(to, body).set_type(:normal).set_id('1').set_subject(subject)
      cl.send(m)
      cl.close
    end
  end
  

end