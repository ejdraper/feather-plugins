module Feather
  module Admin
    class CommentBlacklists < Base
      include_plugin_views __FILE__
      before :find_comment_blacklist, :only => %w(delete)

      def index
        @comment_blacklists = Feather::CommentBlacklist.all
        display @comment_blacklists
      end

      def delete
        # Make sure we have a comment blacklist entry
        @comment_blacklist.destroy unless @comment_blacklist.nil?
        redirect url(:admin_comment_blacklists)
      end

      private
        def find_comment_blacklist
          @comment_blacklist = Feather::CommentBlacklist.get(params[:id])
        end
    end
  end
end