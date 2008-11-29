module Feather
  class TypoTagging < TypoBase
    property :taggable_id, Integer
    property :taggable_type, String
    property :tag_id, Integer
  end
end