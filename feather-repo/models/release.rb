class Release
  include DataMapper::Resource
  
  property :id, Integer, :key => true
  property :name, String, :nullable => false, :length => 255
  property :manifest, String, :length => 255
  property :created_at, DateTime
end