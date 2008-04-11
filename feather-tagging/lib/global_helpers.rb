module Merb
  module GlobalHelpers
    
    def tag_cloud(tags, classes)
      max, min = 0, 0
      tags.each do |t|
        max = t.count.to_i if t.count.to_i > max
        min = t.count.to_i if t.count.to_i < min
      end
      divisor = ((max - min) / classes.size) + 1
      tags.each do |t|
        yield t.name, classes[(t.count.to_i - min) / divisor]
      end
    end
  end
  
end