class Page < DataMapper::Base
  property :parent_id, :integer
  property :user_id, :integer, :nullable => false
  property :title, :string, :nullable => false, :length => 255
  property :permalink, :string, :length => 255
  property :content, :text, :nullable => false
  property :display_in_nav, :boolean, :default => true
  property :position, :integer
  property :meta_description, :text
  property :meta_keywords, :text
  property :created_at, :datetime
  property :published_at, :datetime
  property :published, :boolean, :default => true
  property :formatter, :string, :default => "default"

  validates_presence_of :user_id, :key => "uniq_user_id"
  validates_presence_of :title, :key => "uniq_title"
  validates_presence_of :permalink, :key => "uniq_permalink"
  validates_uniqueness_of :title

  belongs_to :user
  belongs_to :parent, :class => "Page"
  has_many  :children, :class => "Page", :foreign_key => "parent_id", :order => "position"
  has_many  :children_nav, :class => "Page", :foreign_key => "parent_id", :order => "position", :conditions => {:display_in_nav => true}
  
  before_validation :set_published_permalink
  
  def set_published_permalink
    # Set the permalink, only if we haven't already
    self.permalink = title.downcase.gsub(/[^a-z0-9]+/i, '-') if permalink.blank?
    if self.is_published?
      # Set the date, only if we haven't already
      self.published_at = Time.now if self.published_at.nil?
    end
  end
  
  def is_published?
    # We need this because the values get populated from the params
    self.published == "1"
  end
  
  def link
    "/page/#{permalink}"
  end
  
  protected
  def self.published_pages_and_in_nav
    all(:conditions => ['published = 1 AND published_at <= ? AND parent_id = 0 AND display_in_nav = 1', Time.now.utc], :order => "position")
  end

end