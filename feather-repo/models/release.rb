class Release < DataMapper::Base
  property :name, :string, :nullable => false, :length => 255
  property :manifest, :string, :length => 255
  property :created_at, :datetime
end