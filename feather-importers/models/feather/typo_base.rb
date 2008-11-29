module Feather
  class TypoBase
    include DataMapper::Resource
    property :id, Integer, :key => true
  end
end