class Tagging < DataMapper::Base
  property :article_id, :integer
  property :tag_id, :integer

  belongs_to :article
  belongs_to :tag

  before_destroy do |tagging|
    # If this is the last relevant tagging, reap tag.
    unless tagging.tag.taggings.count > 0
      tagging.tag.destroy!
    end
  end

end
