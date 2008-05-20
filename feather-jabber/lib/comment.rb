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
<<<<<<< HEAD:feather-jabber/lib/comment.rb
      article = Article[self.article_id]
      subject = "New comment - RE: #{article.title}"
      commenter_mail="no email"
      if !self.email_address.empty?
        commenter_mail=self.email_address 
      end
      
      commenter_hp="no homepage"
      if !self.website.empty?
        commenter_hp=self.website 
      end
      
      body = "A new comment was posted to #{article.title} at your Blog by #{self.name} (#{commenter_mail} / #{commenter_hp}):\n #{self.comment}"
      #Create a new Jabber connection
      cl = Client::new(JID::new(from))
      #Connect
=======
      subject = "New comment - RE: #{self.article.title}"
      body = "A new comment was posted to #{self.article.title} at your Blog by " + self.name + ":\n\"" + self.comment + "\""
      jid = JID::new(from)
      cl = Client::new(jid)
>>>>>>> 29654722a21eea2b9d2b65d99c979af384f5f365:feather-jabber/lib/comment.rb
      cl.connect
<<<<<<< HEAD:feather-jabber/lib/comment.rb
      #Send password
=======
>>>>>>> 29654722a21eea2b9d2b65d99c979af384f5f365:feather-jabber/lib/comment.rb
      cl.auth(pass)
      m = Message::new(to, body).set_type(:normal).set_id('1').set_subject(subject)
      cl.send(m)
      cl.close
    end
  end
  

end