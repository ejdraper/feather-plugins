class Comment < DataMapper::Base
  property :post_id, :integer
  property :name, :string
  property :website, :string
  property :comment, :text
  property :created_at, :datetime
  
  def all_for_post(post_id, method = 'all')
    # We're using instance_eval here to allow passing in count as the method arugment
    # and reusing this method (e.g. Comment.all_for_post(10, 'count'))
    self.instance_eval(method).(:post_id => post_id, :order => "created_at DESC")
  end
    
end