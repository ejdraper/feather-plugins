module Feather
  module Admin
    class Importers < Base
      include_plugin_views __FILE__

      def show
        render
      end

      def create
        # Process the article feed if specified
        @articles = process_articles(params[:articles_url]) if params[:articles_url] && params[:articles_url] != ""
        # Process the comment feed if specified
        @comments = process_comments(params[:comments_url]) if params[:comments_url] && params[:comments_url] != "" && (defined?(Feather::Comment) && is_plugin_active("feather-comments"))
        # Render the results
        render
      end

      private
        ##
        # This processes the articles feed url
        def process_articles(url)
          # Create an array to store the processed articles
          processed = []
          # Grab the article items from the feed
          articles = (retrieve(url)/"rss"/"channel"/"item")
          # Loop through them
          articles.each do |a|
            # Build the permalink
            permalink = URI.parse((a/"guid").text).request_uri
            # Find the article, or create a new one
            article = Feather::Article.first(:permalink => permalink) || Feather::Article.new
            # Grab the information from the article feed item
            article.title = (a/"title").text
            article.content = (a/"description").text
            article.published = "1"
            article.published_at = DateTime.parse((a/"pubdate").text)
            article.permalink = permalink
            article.user_id = session.user.id
            # Add the tags, if present in the feed, and if the tagging plugin is active
            article.tag_list = (a/"category").collect { |c| c.children.first }.join(",") if is_plugin_active("feather-tagging") && article.respond_to?("tag_list=") && (a/"category") && (a/"category").length > 0
            # Save the article
            article.save
            # Add it to the list of processed articles
            processed << article
          end
          # Return the list of processed articles
          processed
        end

        ##
        # This processes the comments feed url
        def process_comments(url)
          # Ensure the comment plugin exists
          raise "Unable to process comments: comment plugin not detected!" unless defined?(Feather::Comment)
          # Create an array to store the processed comments
          processed = []
          # Grab the comment items from the feed
          comments = (retrieve(url)/"rss"/"channel"/"item")
          # Loop through them
          comments.each do |c|
            # Create a new comment
            comment = Comment.new
            # Grab the information from the comment feed item
            comment.comment = (c/"description").text
            comment.name = (c/"dc:creator").text
            comment.created_at = DateTime.parse((c/"pubdate").text)
            a = Article.first(:title => (c/"title").text.gsub("Re: ", ""))
            comment.article_id = a.id unless a.nil?
            # Save the comment
            comment.save
            # Add it to the list of processed comments
            processed << comment
          end
          # Return the list of processed comments
          processed
        end

        ##
        # This retrieves the content of the specified url
        def retrieve(url)
          Hpricot(Net::HTTP.get(URI.parse(url)))
        end
    end
  end
end