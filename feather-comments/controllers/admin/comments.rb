module Feather
  module Admin
    class Comments < Base
      include_plugin_views __FILE__
      before :find_comment, :only => %w(edit update delete show)

      def index
        @page_count, @comments = Feather::Comment.paginated(:page => params[:page], :per_page => 10, :order => [:created_at.desc])
        display @comments
      end

      def update
        @comment.published = (params[:published] == "true" ? true : false) if params[:published]
        @comment.save
        render_js
      end

      def delete
        @comment.destroy
        redirect url(:admin_comments)
      end

      def show
        display @comment
      end

      private
        def find_comment
          @comment = Comment[params[:id]]
        end
    end
  end
end