class Comment < DataMapper::Base
  property :post_id, :integer
  property :name, :string
  property :website, :string
  property :comment, :text
  property :created_at, :datetime
  
  validates_presence_of :name, :website, :comment
  
  class << self
    def all_for_post(post_id, method = :all)
      self.send(method.to_s, {:post_id => post_id, :order => "created_at DESC"})
    end
  end
end