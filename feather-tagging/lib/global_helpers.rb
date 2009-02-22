module Merb
  module GlobalHelpers    
    def tag_cloud(tags, taggings, classes)
      return "" if tags.nil? || tags.empty?
      max, min = 0, 0
      counter = {}
      taggings.each do |t|
        counter[t[:tag_id]].nil? ? counter[t[:tag_id]] = 1 : counter[t[:tag_id]] += 1
      end
      tags.each do |t|
        count = counter[t[:id]] || 0
        max = count if count > max
        min = count if count < min
      end
      divisor = ((max - min) / classes.size) + 1
      tags.each do |t|
        count = counter[t[:id]] || 0
        yield t, classes[count / divisor] unless count == 0
      end
    end
  end
end
