class MephistoSection
  include DataMapper::Resource

  def self.default_repository_name
    :mephisto_database
  end

  storage_names[:mephisto_database] = "sections"

  property :id, Integer, :key => true
  property :name, String
end
