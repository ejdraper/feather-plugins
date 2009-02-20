module Feather
  module Admin
    class Comments < Base
      include_plugin_views __FILE__
      before :find_comment, :only => %w(delete show)

      def index
        @page_count, @comments = Feather::Comment.paginated(:page => (params[:page] || 1).to_i, :per_page => 20, :order => [:created_at.desc])
        display @comments
      end

      def delete
        # Make sure we have a comment
        unless @comment.nil?
          # See if we're marking this as spam (i.e. looking to remove others just like it)
          if params[:spam] && params[:spam] == "true"
            # If so, we want to remove all other comments with the same IP, e-mail, website or name
            Feather::Comment.all(:conditions => {:ip_address => @comment.ip_address}).each { |c| c.destroy }
            Feather::Comment.all(:conditions => {:email_address => @comment.email_address}).each { |c| c.destroy }
            Feather::Comment.all(:conditions => {:website => @comment.website}).each { |c| c.destroy }
            Feather::Comment.all(:conditions => {:name => @comment.name}).each { |c| c.destroy }
          end
          # Now remove the comment itself
          @comment.destroy
        end
        redirect url(:admin_comments)
      end

      def show
        display @comment
      end

      private
        def find_comment
          @comment = Feather::Comment.get(params[:id])
        end
    end
  end
end