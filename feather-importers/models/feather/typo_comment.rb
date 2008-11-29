module Feather
  class TypoComment < TypoBase
    property :article_id, Integer
    property :body_html, String
    property :author, String
    property :published_at, DateTime
    property :author_url, String
    property :author_email, String
  end
end