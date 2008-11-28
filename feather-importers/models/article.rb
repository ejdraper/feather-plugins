class MephistoArticle
  include DataMapper::Resource

  def self.default_repository_name
    :mephisto_database
  end

  storage_names[:mephisto_database] = "contents"

  property :id, Integer, :key => true
  property :title, String
  property :filter, String
  property :type, String
  property :body, Text
#  property :published_at, DateTime
  property :permalink, String
end
