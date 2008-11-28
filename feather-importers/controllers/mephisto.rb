module Admin
  class Mephisto < Base
    include_plugin_views __FILE__
    @article_map = {}
    
    def show
      render
    end

    def create
      
      DataMapper.setup(:mephisto_database, {
         :adapter  => params[:adapter],
         :host     => params[:host],
         :username => params[:user],
         :password => params[:password],
         :database => params[:database]
        })
      
      @article_map = {}  
        
      DataMapper.repository(:mephisto_database) do
        @mephisto_articles = collect_mephisto_articles()
        @mephisto_comments = collect_mephisto_comments()
      end
      @articles = process_articles(@mephisto_articles, params[:permalink]) unless @mephisto_articles.nil?
      @comments = process_comments(@mephisto_comments) unless @mephisto_comments.nil?
      
      render
    end

    private
    
      def format_permalink(format, date, title)
        format = format.gsub(/:year/,date.year.to_s)
        format.gsub!(/:month/,date.month.to_s)
        format.gsub!(/:day/,Padding::pad_single_digit(date.day))
        title = title.gsub(/\W+/, ' ') # all non-word chars to spaces
        title.strip!            # ohh la la
        title.downcase!         #
        title.gsub!(/\ +/, '-') # spaces to dashes, preferred separator char everywhere
        format.gsub!(/:title/,title)
        format
      end
    
      # Collects the mephisto comments
      def collect_mephisto_comments()
        if MephistoComment.storage_exists? 
          MephistoComment.all(:type => "Comment")
        else
          nil
        end
      end

      # Collects the mephisto articles
      def collect_mephisto_articles()
        if MephistoArticle.storage_exists? 
          MephistoArticle.all(:type => "Article")
        else
          nil
        end
      end

      def formatter(filter)
        case filter
        when 'markdown_filter', 'smartypants_filter'
          'markdown'
        when 'textile_filter'
          'textile'
        else
          'default'
        end
      end

      ##
      # This processes the articles data
      def process_articles(mephisto_articles, permalink_format)
        # Create an array to store the processed articles
        processed = []
 
        # Loop through them
        mephisto_articles.each do |a|
          # Find the article, or create a new one
          article = Article.new
          # Grab the information from the article feed item
          article.title = a.title
          article.content = a.body
          article.formatter = formatter(a.filter)
          article.published = "1"
          article.published_at = DateTime.now
          article.permalink = format_permalink(permalink_format,DateTime.now,a.title)
          article.user_id = self.current_user.id
          
          
          # Add the tags, if present in the feed, and if the tagging plugin is active
          if is_plugin_active("feather-tagging") && defined?(Tag) && defined?(Tagging) && article.respond_to?("tag_list=")
            tags = []
            sections = []
            
            DataMapper.repository(:mephisto_database) do
              taggings = MephistoTagging.all(:taggable_id => a.id)
              tags = MephistoTag.all(:id => taggings.collect{|tg| tg.tag_id}.join(',')) unless taggings.empty? 
            
              assigned_sections = MephistoAssignedSection.all(:article_id => a.id)
              sections = MephistoSection.all(:sections => assigned_sections.collect{|as| as.section_id}.join(',')) unless assigned_sections.empty?
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
      

      ##
      # This processes the comments data
      def process_comments(mephisto_comments)
        # Ensure the comment plugin exists
        raise "Unable to process comments: comment plugin not detected!" unless defined?(Comment)
        # Create an array to store the processed comments
        processed = []
       
        # Loop through them
        mephisto_comments.each do |c|
          # Create a new comment
          comment = Comment.new
          
          # Grab the information from the comment
          comment.comment = c.body
          comment.name = c.author
          comment.formatter = formatter(c.filter)
          comment.website = ''
          if c.author_url && c.author_url != "http://null"
            comment.website = c.author_url
          end
          comment.email_address = c.author_email
          comment.created_at = c.published_at
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
