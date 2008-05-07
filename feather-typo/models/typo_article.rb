class TypoArticle < TypoBase
  property :title, :string
  property :content, :string
  property :published_at, :datetime
  property :permalink, :string
end