class MephistoComment
  include DataMapper::Resource

  def self.default_repository_name
    :mephisto_database
  end

  storage_names[:mephisto_database] = "comments"

  property :id, Integer, :key => true

  property :article_id, Integer
  property :type, String
  property :body_html, String
  property :author, String
  property :published_at, DateTime
  property :author_url, String
  property :author_email, String
end
