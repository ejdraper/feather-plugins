class Tagging
  include DataMapper::Resource
  
  property :id, Integer, :key => true
  property :article_id, Integer
  property :tag_id, Integer

  belongs_to :article
  belongs_to :tag

end
