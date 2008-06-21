class Style
  include DataMapper::Resource
  
  property :id, Integer, :key => true
  property :name, String, :nullable => false, :length => 255
  property :content, Text, :nullable => false
end