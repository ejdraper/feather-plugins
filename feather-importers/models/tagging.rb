class MephistoTagging
  include DataMapper::Resource

  def self.default_repository_name
    :mephisto_database
  end

  storage_names[:mephisto_database] = "taggings"

  property :id, Integer, :key => true

  property :taggable_id, Integer
  property :taggable_type, String
  property :tag_id, Integer
end
