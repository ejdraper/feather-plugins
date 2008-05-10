##
# Reopen the article model and wang in the stuff we need
class Article
  # We define this tags attribute so when the form posts, the params for tags get set, and we can subsequently access it later on
  attr_accessor :tag_list
  has_many :taggings

  def create_tags
    return if @tag_list.nil? || @tag_list.empty?
    # Wax all the existing taggings
    self.taggings.each {|t| t.destroy! }
    @tag_list.split(",").each do |t|
      unless t.empty?
        tag = Tag.find_or_create(:name => t.strip.downcase) 
        Tagging.create(:article_id => self.id, :tag_id => tag.id)
      end
    end
  end

  def tags
    taggings.map { |tagging| tagging.tag.name }.join(", ")
  end
end