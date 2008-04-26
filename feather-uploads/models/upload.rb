class Upload < DataMapper::Base
  property :url, :string, :nullable => false, :length => 255
  property :content_type, :string, :nullable => false, :length => 255
  property :size, :integer
  property :created_at, :datetime, :nullable => false

  validates_presence_of :url, :key => "uniq_url"
  validates_presence_of :content_type, :key => "uniq_content_type"
  validates_presence_of :size, :key => "uniq_size"
end