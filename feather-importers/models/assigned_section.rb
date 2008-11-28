class MephistoAssignedSection
  include DataMapper::Resource

  def self.default_repository_name
    :mephisto_database
  end
  
  storage_names[:mephisto_database] = "assigned_sections"

  property :id, Integer, :key => true

  property :article_id, Integer
  property :section_id, Integer
end
