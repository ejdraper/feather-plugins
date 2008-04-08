class Feeds < Application
  def articles
    @articles = Article.all(:published => true, :limit => 15, :order => "published_at DESC")
    rss = ""
    xml = Builder::XmlMarkup.new(:target => rss)
    xml.instruct!
    xml.rss "version" => "2.0" do
      xml.channel do
        xml.title         Configuration.first.title
        xml.link          "http://#{request.env['HTTP_HOST']}#{request.uri}"
        xml.pubDate       rfc822(@articles.first.published_at) if @articles.length > 0
        xml.description   Configuration.first.tag_line
        @articles.each do |article|
          xml.item do
            xml.title         article.title
            xml.link          "http://#{request.env['HTTP_HOST']}#{article.permalink}"
            xml.description   RedCloth.new(article.content).to_html
            xml.pubDate       rfc822(article.published_at)
            xml.guid          "http://#{request.env['HTTP_HOST']}#{article.permalink}"
            xml.author        article.user.login
          end
        end
      end
    end
    rss
  end
  
  def comments
    @comments = (defined?(Comment) && is_plugin_active("feather-comments")) ? Comment.all(:limit => 15, :order => "created_at DESC") : []
    rss = ""
    xml = Builder::XmlMarkup.new(:target => rss)
    xml.instruct!
    xml.rss "version" => "2.0" do
      xml.channel do
        xml.title         "#{Configuration.first.title}: comments"
        xml.link          "http://#{request.env['HTTP_HOST']}#{request.uri}"
        xml.pubDate       rfc822(@comments.first.created_at) if @comments.length > 0
        xml.description   Configuration.first.tag_line
        @comments.each do |comment|
          article = Article[comment.article_id]
          if article
            xml.item do
              xml.title         "Re: #{article.title}"
              xml.link          "http://#{request.env['HTTP_HOST']}#{article.permalink}##{comment.id}"
              xml.description   RedCloth.new(comment.comment).to_html
              xml.pubDate       rfc822(comment.created_at)
              xml.guid          "http://#{request.env['HTTP_HOST']}#{article.permalink}##{comment.id}"
              xml.author        comment.name
            end
          end
        end
      end
    end
    rss
  end

  # Returns the specified time in RFC822 format
  def rfc822(time)
    time.strftime("%a, %d %b %Y %H:%M:%S GMT")
  end
end