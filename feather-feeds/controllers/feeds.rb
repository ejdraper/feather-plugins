class Feeds < Application
  before :find_feed_setting

  def articles
    @articles = Article.all(:published => true, :limit => @feed_setting.article_count, :order => "published_at DESC")
    output = ""
    xml = Builder::XmlMarkup.new(:target => output)
    xml.instruct!
    case params[:format]
    when "rss"
      xml.rss "version" => "2.0" do
        xml.channel do
          xml.title         Configuration.current.title
          xml.link          "http://#{request.env['HTTP_HOST']}#{request.uri}"
          xml.pubDate       rfc822(@articles.first.published_at) if @articles.length > 0
          xml.description   Configuration.current.tag_line
          @articles.each do |article|
            xml.item do
              xml.title         article.title
              xml.link          "http://#{request.env['HTTP_HOST']}#{article.permalink}"
              xml.description   render_article(article)
              xml.pubDate       rfc822(article.published_at)
              xml.guid          "http://#{request.env['HTTP_HOST']}#{article.permalink}"
              xml.author        article.user.name || article.user.login
            end
          end
        end
      end
    when "atom"
      xml.feed "xmlns" => "http://www.w3.org/2005/Atom" do
        xml.title           Configuration.current.title
        xml.subtitle        Configuration.current.tag_line
        # Leave that one out for the moment
        #xml.link            :href => "http://#{request.env['HTTP_HOST']}/atom", :rel => "self"
        xml.link            :href => "http://#{request.env['HTTP_HOST']}"
        # The parentheses are needed, otherwise one gets a pretty weird error complaining about String not having strftime
        xml.updated(        (@articles.any? ? @articles.first.published_at : DateTime.now).strftime("%Y-%m-%dT%H:%M:%SZ"))
        xml.id              "http://#{request.env['HTTP_HOST']}#{request.uri}"
        @articles.each do |article|
          xml.entry do
            xml.title       article.title
            xml.link        :href => "http://#{request.env['HTTP_HOST']}#{article.permalink}"
            xml.id          "http://#{request.env['HTTP_HOST']}#{article.permalink}"
            xml.updated     article.published_at.strftime("%Y-%m-%dT%H:%M:%SZ")
            xml.author do
              xml.name      article.user.name || article.user.login
            end
            xml.content :type => "html" do
              xml.text! render_article(article)
            end
          end
        end
      end
    else
      render :status => 404
    end
    output
  end

  def comments
    @comments = (defined?(Comment) && is_plugin_active("feather-comments")) ? Comment.all(:limit => @feed_setting.comment_count, :order => "created_at DESC") : []
    rss = ""
    xml = Builder::XmlMarkup.new(:target => rss)
    xml.instruct!
    xml.rss "version" => "2.0" do
      xml.channel do
        xml.title         "#{Configuration.current.title}: comments"
        xml.link          "http://#{request.env['HTTP_HOST']}#{request.uri}"
        xml.pubDate       rfc822(@comments.first.created_at) if @comments.length > 0
        xml.description   Configuration.current.tag_line
        @comments.each do |comment|
          article = Article[comment.article_id]
          if article
            xml.item do
              xml.title         "Re: #{article.title}"
              xml.link          "http://#{request.env['HTTP_HOST']}#{article.permalink}##{comment.id}"
              xml.description   render_text("default", comment.comment)
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

  private
    def find_feed_setting
      @feed_setting = FeedSetting.current
    end

    ##
    # This returns the specified time in RFC822 format
    def rfc822(time)
      time.strftime("%a, %d %b %Y %H:%M:%S GMT")
    end
end