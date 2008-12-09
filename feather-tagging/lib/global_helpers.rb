module Merb
  module GlobalHelpers    
    def tag_cloud(tags, classes)
      return "" if tags.nil? || tags.empty?
      max, min = 0, 0
      tags.each do |t|
        count = ::Feather::Article.tagged_with(t.name).size.to_i
        max = count if count > max
        min = count if count < min
      end
      divisor = ((max - min) / classes.size) + 1
      tags.each do |t|
        count = ::Feather::Article.tagged_with(t.name).size.to_i
        yield t, classes[count / divisor] unless count == 0
      end
    end
  end
end
