class Upload
  include DataMapper::Resource
  
  property :id, Integer, :serial => true
  property :url, String, :nullable => false, :length => 255
  property :content_type, String, :nullable => false, :length => 255
  property :size, Integer
  property :created_at, DateTime, :nullable => false

  validates_present :url, :key => "uniq_url"
  validates_present :content_type, :key => "uniq_content_type"
  validates_present :size, :key => "uniq_size"
end
