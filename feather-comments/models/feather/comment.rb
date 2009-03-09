module Feather
  class Comment
    include DataMapper::Resource

    include Splam
    splammable :comment do |splam|
      splam.threshold  = 40
      splam.rules     = [:bad_words, :html, :bbcode, :href]
    end
    
    is_paginated
  
    property :id, Integer, :serial => true
    property :article_id, Integer
    property :name, String
    property :website, String
    property :comment, Text
    property :created_at, DateTime
    property :email_address, String
    property :formatter, String, :default => "default"
    property :ip_address, String, :default => "127.0.0.1"
  
    belongs_to :article

    validates_present :name, :comment, :article_id

    before :save, :check_for_spam
    def check_for_spam
      throw :halt if self.splam?
    end

    before :save, :prepend_http_if_needed
    belongs_to :article  
    after :save, :fire_after_comment_event
    after :create, :set_create_activity
    after :save, :expire_cache
    after :destroy, :expire_cache
    
    # Dummy honeypot propery
    attr_accessor :title
    
    # This expires the article page that the comment belongs to
    def expire_cache
      Feather::Article.expire_article_page(self.article_id)
    end

    def self.all_for_post(article_id, method = :all)
      self.send(method, {:article_id => article_id, :order => [:created_at.asc]})
    end

    ##
    # This provides an event hook for other plugins to use (if they detect the comments plugin is installed), and they can then pick up on the comment being saved
    def fire_after_comment_event
      Feather::Hooks::Events.run_event(:after_comment, self)
    end
  
    def prepend_http_if_needed
      if !self.website.nil? && self.website.strip! && !self.website.empty?
        protocol = "http://"
        self.website.insert(0, protocol) if self.website.rindex(protocol).nil?
      end
    end
  
    def set_create_activity
      # This is lame, but for some reason the association (self.article) isn't available yet.
      a = Feather::Activity.create(:message => "Comment created by \"#{self.name}\" on #{Feather::Article[self.article_id].title}")
    end
  end
end