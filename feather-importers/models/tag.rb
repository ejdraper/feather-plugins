class MephistoTag
  include DataMapper::Resource

  def self.default_repository_name
    :mephisto_database
  end
  
  storage_names[:mephisto_database] = "tags"

  property :id, Integer, :key => true

  property :name, String
end
