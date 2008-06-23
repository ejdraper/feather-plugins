class Page
  include DataMapper::Resource
  
  property :id, Integer, :key => true, :serial => true
  property :parent_id, Integer
  property :user_id, Integer, :nullable => false
  property :title, String, :nullable => false, :length => 255
  property :permalink, String, :length => 255
  property :content, Text, :nullable => false
  property :display_in_nav, Boolean, :default => true
  property :position, Integer
  property :meta_description, Text
  property :meta_keywords, Text
  property :created_at, DateTime
  property :published_at, DateTime
  property :published, Boolean, :default => true
  property :formatter, String, :default => "default"

  validates_present :user_id, :key => "uniq_user_id"
  validates_present :title, :key => "uniq_title"
  validates_present :permalink, :key => "uniq_permalink"
  validates_is_unique :title

  belongs_to :user
  belongs_to :parent, :class_name => "Page"
  has n, :children, :class_name => "Page", :child_key => [:parent_id], :order => [:position.desc]
  has n, :children_nav, :class_name => "Page", :child_key => [:parent_id], :order => [:position.desc], :display_in_nav => true
  
  before :save, :set_published_permalink
  
  def set_published_permalink
    # Set the permalink, only if we haven't already
    self.permalink = title.downcase.gsub(/[^a-z0-9]+/i, '-') if permalink.blank?
    if self.published
      # Set the date, only if we haven't already
      self.published_at = Time.now if self.published_at.nil?
    end
  end
  
  def link
    "/page/#{permalink}"
  end
  
  protected
  def self.published_pages_and_in_nav
    self.all(:published => true, :published_at.lte => Time.now.utc, :parent_id => 0, :display_in_nav => true, :order => [:position.asc])
  end
end