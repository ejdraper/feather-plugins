class Comment < DataMapper::Base
  property :article_id, :integer
  property :name, :string
  property :website, :string
  property :comment, :text
  property :created_at, :datetime
  property :email_address, :string
  property :formatter, :string, :default => "default"
  property :ip_address, :string, :default => "127.0.0.1"
  property :published, :boolean, :default => true
  
  belongs_to :article

  validates_presence_of :name, :comment, :article_id

  before_save :prepend_http_if_needed
  belongs_to :article  
  after_save :fire_after_comment_event
  after_create :set_create_activity

  def self.all_for_post(article_id, method = :all)
    self.send(method, {:article_id => article_id, :published => true, :order => "created_at"})
  end

  ##
  # This provides an event hook for other plugins to use (if they detect the comments plugin is installed), and they can then pick up on the comment being saved
  def fire_after_comment_event
    Hooks::Events.run_event(:after_comment, self)
  end
  
  def prepend_http_if_needed
    if !self.website.nil? && self.website.strip! && !self.website.empty?
      #--> jf quick qn: is there a way to prevent DM from saving empty string as nil? (and NO, despite the '.strip!', this is NOT the culprit)
      #--> '!self.website.empty?' for the first save before approval, '!self.website.nil?' for when "" ends up getting saved as nil
      protocol = "http://"
      self.website.insert(0, protocol) if self.website.rindex(protocol).nil?
    end
  end
  
  def set_create_activity
    # This is lame, but for some reason the association (self.article) isn't available yet.
    a = Activity.create(:message => "Comment created by \"#{self.name}\" on #{Article[self.article_id].title}")
  end
  
end