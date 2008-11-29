module Feather
  module Admin
    class CommentSettings < Base
      include_plugin_views __FILE__
      before :find_comment_setting

      def show
        display @comment_setting
      end

      def edit
        display @comment_setting
      end

      def update(comment_setting)
        if @comment_setting.update_attributes(comment_setting)
          redirect url(:admin_comment_setting)
        else
          render :edit
        end
      end
    
      private
        def find_comment_setting
          @comment_setting = CommentSetting.current
        end
    end
  end
end