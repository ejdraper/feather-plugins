class Tag < DataMapper::Base
  property :name, :string
  has_and_belongs_to_many :taggings

  # Has many through would be nice here.
  def articles
    Article.all(:id => taggings.map{|t| t.article_id }) # So tempted to use symbol to_proc but, it's slow. Damn.
  end
  
  def to_param
    name
  end
    
end