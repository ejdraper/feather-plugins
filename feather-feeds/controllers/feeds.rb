module Feather
  class Feeds < Application
    before :find_feed_setting

    def articles
      @articles = Feather::Article.all(:published => true, :limit => @feed_setting.article_count, :order => [:published_at.desc])
      output = ""
      xml = ::Builder::XmlMarkup.new(:target => output)
      xml.instruct!
      case params[:format]
      when "rss"
        content_type :rss
        xml.rss "version"    => "2.0",
                "xmlns:dc"   => "http://purl.org/dc/elements/1.1/",
                "xmlns:atom" => "http://www.w3.org/2005/Atom" do
          xml.channel do
            xml.title         Feather::Configuration.current.title
            xml.atom :link,   :href => "http://#{request.host}#{request.uri}", :rel => "self"
            xml.link          "http://#{request.host}#{request.uri}"
            xml.pubDate       rfc822(@articles.first.published_at) if @articles.length > 0
            xml.description   Feather::Configuration.current.tag_line
            @articles.each do |article|
              xml.item do
                xml.title         article.title
                xml.link          "http://#{request.host}#{article.permalink}"
                xml.description   render_article(article)
                xml.pubDate       rfc822(article.published_at)
                xml.guid          "http://#{request.host}#{article.permalink}"
                xml.dc :creator,  article.user.name || article.user.login
              end
            end
          end
        end
      when "atom"
        content_type :atom
        xml.feed "xmlns" => "http://www.w3.org/2005/Atom" do
          xml.title           Feather::Configuration.current.title
          xml.subtitle        Feather::Configuration.current.tag_line if Feather::Configuration.current.tag_line
          xml.link            :href => "http://#{request.host}#{request.uri}", :rel => "self"
          xml.link            :href => "http://#{request.host}"
          # The parentheses are needed, otherwise one gets a pretty weird error complaining about String not having strftime
          xml.updated(        (@articles.any? ? @articles.first.published_at : DateTime.now).strftime("%Y-%m-%dT%H:%M:%SZ"))
          xml.id              "http://#{request.host}#{request.uri}"
          @articles.each do |article|
            xml.entry do
              xml.title       article.title
              xml.link        :href => "http://#{request.host}#{article.permalink}"
              xml.id          "http://#{request.host}#{article.permalink}"
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
      @comments = (defined?(Feather::Comment) && is_plugin_active("feather-comments")) ? Feather::Comment.all(:limit => @feed_setting.comment_count, :order => [:created_at.desc]) : []
      output = ""
      xml = Builder::XmlMarkup.new(:target => output)
      xml.instruct!
      case params[:format]
      when "rss"
        content_type :rss
        xml.rss "version"    => "2.0",
                "xmlns:dc"   => "http://purl.org/dc/elements/1.1/",
                "xmlns:atom" => "http://www.w3.org/2005/Atom" do
          xml.channel do
            xml.title         "#{Feather::Configuration.current.title}: comments"
            xml.atom :link,   :href => "http://#{request.host}#{request.uri}", :rel => "self"
            xml.link          "http://#{request.host}#{request.uri}"
            xml.pubDate       rfc822(@comments.first.created_at) if @comments.length > 0
            xml.description   Configuration.current.tag_line
            @comments.each do |comment|
              article = Feather::Article[comment.article_id]
              if article
                xml.item do
                  xml.title         "Re: #{article.title}"
                  xml.link          "http://#{request.host}#{article.permalink}##{comment.id}"
                  xml.description   render_text("default", comment.comment)
                  xml.pubDate       rfc822(comment.created_at)
                  xml.guid          "http://#{request.host}#{article.permalink}##{comment.id}"
                  xml.dc :creator,  comment.name
                end
              end
            end
          end
        end
      when "atom"
        content_type :atom
        xml.feed "xmlns" => "http://www.w3.org/2005/Atom" do
          xml.title           Feather::Configuration.current.title
          xml.subtitle        Feather::Configuration.current.tag_line if Feather::Configuration.current.tag_line
          xml.link            :href => "http://#{request.host}#{request.uri}", :rel => "self"
          xml.link            :href => "http://#{request.host}"
          # The parentheses are needed, otherwise one gets a pretty weird error complaining about String not having strftime
          xml.updated(        (@comments.any? ? @comments.first.created_at : DateTime.now).strftime("%Y-%m-%dT%H:%M:%SZ"))
          xml.id              "http://#{request.host}#{request.uri}"
          @comments.each do |comment|
            article = Feather::Article[comment.article_id]
            if article
              xml.entry do
                xml.title       "Re: #{article.title}"
                xml.link        :href => "http://#{request.host}#{article.permalink}##{comment.id}"
                xml.id          "http://#{request.host}#{article.permalink}##{comment.id}"
                xml.updated     comment.created_at.strftime("%Y-%m-%dT%H:%M:%SZ")
                xml.author do
                  xml.name      comment.name
                end
                xml.content :type => "text" do
                  xml.text! render_text("default", comment.comment)
                end
              end
            end
          end
        end
      else
        render :status => 404
      end
      output
    end

    private
      def find_feed_setting
        @feed_setting = Feather::FeedSetting.current
      end

      ##
      # This returns the specified time in RFC822 format
      def rfc822(time)
        time.strftime("%a, %d %b %Y %H:%M:%S GMT")
      end
  end
end