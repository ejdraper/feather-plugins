# Reopen the article model and wang in the stuff we need. 
class Article
  # We define this tags attribute so when the form posts, the params for
  # tags get set, and we can subsequently access it later on.
  attr_accessor :tag_list
  
  has_many :taggings
  # Datamapper's version of has_many :through. Not quite as pretty, but it'll get the job done. Or not...
  # This is supposed to work but it just returns a #<DataMapper::Support::TypedSet[Tag]: {}>
  # has_and_belongs_to_many :tags,
  #   :join_table => "taggings",
  #   :left_foreign_key => "article_id",
  #   :right_foreign_key => "tag_id",
  #   :class => "Tag"
      
  def create_tags
    return if @tag_list.nil? || @tag_list.empty?
    # Wax all the existing taggings.
    self.taggings.each {|t| t.destroy! }
    @tag_list.split(",").each do |t|
      unless t.empty?
        # Hmm, can we do transactions with DM? I'm sure there's a way.
        tag = Tag.create(:name => t.strip) 
        Tagging.create(:article_id => self.id, :tag_id => tag.id)
      end
    end
  end
  
  after_save do |article|
    article.create_tags
  end
  
  # This is probably slower than habtm, but that's not working as stated above.
  def tags
    taggings.map { |tagging| tagging.tag.name }.join(", ")
  end
    
end
