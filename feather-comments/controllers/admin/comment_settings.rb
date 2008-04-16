module Admin
  class CommentSettings < Base
    include_plugin_views __FILE__
    
    def show
      @comment_setting = CommentSetting.current
      display @comment_setting
    end
    
    def edit
      @comment_setting = CommentSetting.current
      display @comment_setting
    end
    
    def update(comment_setting)
      @comment_setting = CommentSetting.current
      if @comment_setting.update_attributes(comment_setting)
        redirect url(:admin_comment_settings, @comment_setting)
      else
        render :edit
      end
    end
  end
end