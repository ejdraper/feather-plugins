class Style < DataMapper::Base
  property :name, :string, :nullable => false, :length => 255
  property :content, :text, :nullable => false
end