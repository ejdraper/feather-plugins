class Tag < DataMapper::Base
  property :name, :string
  property :permalink, :string
  has_and_belongs_to_many :taggings

  before_create do |tag|
    tag.permalink = tag.name.downcase.gsub(/[^a-z0-9]+/i, '-')
  end

  ##
  # Has many through would be nice here
  def articles
    Article.all(:id => taggings.map{|t| t.article_id })
  end

  def to_param
    permalink
  end
end