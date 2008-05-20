class Tagging < DataMapper::Base
  property :article_id, :integer
  property :tag_id, :integer

  belongs_to :article
  belongs_to :tag

end
