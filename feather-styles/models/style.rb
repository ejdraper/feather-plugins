class Style
  include DataMapper::Resource
  
  property :id, Integer, :serial => true
  property :name, String, :nullable => false, :length => 255
  property :content, Text, :nullable => false
end
