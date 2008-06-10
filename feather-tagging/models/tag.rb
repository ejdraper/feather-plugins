class Tag
  include DataMapper::Resource
  
  property :id, Integer, :key => true
  property :name, String
  property :permalink, String
  has 0..n, :taggings

  before :create do |tag|
    tag.permalink = tag.name.downcase.gsub(/[^a-z0-9]+/i, '-')
  end

  ##
  # Has many through would be nice here
  def articles
    Article.all(:id => taggings.map{|t| t.article_id }, :published => true)
  end

  def to_param
    permalink
  end
end