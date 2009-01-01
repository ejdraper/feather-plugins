module Feather
  module Admin
    class Typos < Base
      include_plugin_views __FILE__
      @article_map = {}
    
      def show
        render
      end

      def create
        DataMapper::Database.setup(:typo_database, {
           :adapter  => params[:adapter],
           :host     => params[:host],
           :socket => params[:socket],
           :username => params[:user],
           :password => params[:password],
           :database => params[:database]
          })
        @article_map = {}  
        DataMapper.database(:typo_database) do
          @typo_articles = collect_typo_articles()
          @typo_comments = collect_typo_comments()
        end
        @articles = process_articles(@typo_articles, params[:permalink])
        @comments = process_comments(@typo_comments)
        render
      end

      private
        def format_permalink(format, date, title)
          format = format.gsub(/:year/,date.year.to_s)
          format.gsub!(/:month/, Feather::Padding::pad_single_digit(date.month))
          format.gsub!(/:day/, Feather::Padding::pad_single_digit(date.day))
          title = title.gsub(/\W+/, ' ') # all non-word chars to spaces
          title.strip!            # ohh la la
          title.downcase!         #
          title.gsub!(/\ +/, '-') # spaces to dashes, preferred separator char everywhere
          format.gsub!(/:title/,title)
          format
        end
    
        # Collects the typo articles
        def collect_typo_articles()
          Feather::TypoArticle.find_by_sql("select * from contents where type = 'Article'")
        end
      
        ##
        # This processes the articles feed url
        def process_articles(typo_articles, permalink_format)
          # Create an array to store the processed articles
          processed = []
          current_article = 0
          # Loop through them
          typo_articles.each do |a|
            current_article += 1
            puts "Processing: " + current_article.to_s + "/" + typo_articles.size.to_s + ": " + a.title
            # Find the article, or create a new one
            article = Feather::Article.new
            # Grab the information from the article feed item
            article.title = a.title
            article.content = a.body
            article.published = "1"
            d = DateTime.parse(a.published_at)
            article.published_at = d
            article.permalink = format_permalink(permalink_format,d,a.title)
            article.user_id = session.user.id
          
            # Add the tags, if present in the feed, and if the tagging plugin is active
            if is_plugin_active("feather-tagging") && defined?(Feather::Tag) && defined?(Feather::Tagging) && article.respond_to?("tag_list=")
              tags = []
              sections = []
            
              DataMapper.database(:typo_database) do
                taggings = Feather::TypoTagging.find_by_sql("select * from articles_tags where article_id = #{a.id}")
                tags = Feather::TypoTag.find_by_sql("select * from tags where id in (#{taggings.collect{|tg| tg.tag_id}.join(',')})") unless taggings.empty?
            
                assigned_sections = Feather::TypoAssignedSection.find_by_sql("select * from categorizations where article_id = #{a.id}")
                sections = Feather::TypoSection.find_by_sql("select * from categories where id in (#{assigned_sections.collect{|as| as.category_id}.join(',')})") unless assigned_sections.empty?
              end
            
              article.tag_list = (tags.collect{|tag| tag.name} + sections.collect{|section| section.name}).compact.join(",")
            end
          
            # Save the article
            article.save
          
            @article_map[a.id] = article.id
          
            # Add it to the list of processed articles
            processed << article
          end
        
          # Return the list of processed articles
          processed
        end
      
        # Collects the typo comments
        def collect_typo_comments()
          Feather::TypoComment.find_by_sql("select * from feedback where type = 'Comment'")
        end

        ##
        # This processes the comments feed url
        def process_comments(typo_comments)
          # Ensure the comment plugin exists
          raise "Unable to process comments: comment plugin not detected!" unless defined?(Feather::Comment)
          # Create an array to store the processed comments
          processed = []
       
          # Loop through them
          typo_comments.each do |c|
            # Create a new comment
            comment = Feather::Comment.new
          
            # Grab the information from the comment
            comment.comment = c.body
            comment.name = c.author
            comment.website = ''
            if c.url && c.url != "http://null"
              comment.website = c.url
            end
            comment.email_address = c.email
            comment.created_at = c.created_at
            comment.article_id = @article_map[c.article_id]
          
            # Save the comment
            comment.save
          
            # Add it to the list of processed comments
            processed << comment
          end
          # Return the list of processed comments
          processed
        end
    end
  end
end