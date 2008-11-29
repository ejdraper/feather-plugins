module Feather
  class TypoArticle < TypoBase
    property :title, String
    property :content, String
    property :published_at, DateTime
    property :permalink, String
  end
end