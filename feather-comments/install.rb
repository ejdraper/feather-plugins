begin
  comments = Comment.all
rescue
  comments = []
end
Database::migrate(Comment)
comments.each do |comment|
  comment.instance_variable_set("@new_record", true)
  comment.save
end

begin
  comment_settings = CommentSetting.first
rescue
  comment_settings = nil
end
Database::migrate(CommentSetting)
unless comment_settings.nil?
  comment_settings.instance_variable_set("@new_record", true)
  comment_settings.save
end