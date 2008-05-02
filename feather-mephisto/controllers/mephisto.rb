module Admin
  class Importer < Base
    include_plugin_views __FILE__
    @article_map = {}
    
    def show
      render
    end

    def create
      if parameters_met
        DataMapper::Database.setup(:mephisto_database, {
           :adapter  => params[:adapter]
           :host     => params[:host]
           :username => params[:user]
           :password => params[:password]
           :database => params[:database]
          })
        
        @article_map = {}  
          
        DataMapper.database(:mephisto_database) do
          @mephisto_articles = collect_mephisto_articles()
          @mephisto_comments = collect_mephisto_comments()
        end
          
        @articles = process_articles(@mephisto_articles)
        @comments = process_comments(@mephisto_comments)
      end
      render
    end

    private
    
      # Collects the mephisto articles
      def collect_mephisto_articles()
        MephistoArticle.find_by_sql("select * from contents where type = 'Article'")
      end
      
      ##
      # This processes the articles feed url
      def process_articles(mephisto_articles)
        # Create an array to store the processed articles
        processed = []
        
        # Loop through them
        mephisto_articles.each do |a|
          
          # Find the article, or create a new one
          article = Article.first(:permalink => permalink) || Article.new
          # Grab the information from the article feed item
          article.title = a.title
          article.content = a.body_html
          article.published = "1"
          article.published_at = a.published_at
          article.permalink = a.permalink
          article.user_id = self.current_user.id
          
          # Add the tags, if present in the feed, and if the tagging plugin is active
          if is_plugin_active("feather-tagging") && defined?(Tag) && defined?(Tagging) && article.respond_to?("tag_list=")
            taggings = MephistoTagging.find_by_sql("select * from taggings where taggable_id = #{a.id}")
            tags = MephistoTag.find_by_sql("select * from tags where id in (#{taggings.collect{|tg| tg.id}.join(',')})")
            
            assigned_sections = MephistoAssignedSection.find_by_sql("select * from assigned_sections where article_id = #{a.id}")
            sections = MephistoSection.find_by_sql("select * from sections where id in (#{assigned_sections.collect{|as| as.id}.join(',')})")
            
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
      
      # Collects the mephisto comments
      def collect_mephisto_comments()
        MephistoComment.find_by_sql("select * from contents where type = 'Comment'")
      end

      ##
      # This processes the comments feed url
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
          comment.comment = c.body_html
          comment.name = c.author
          comment.created_at = c.published_at
          comment.article_id = @article_map[c.id]
          
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