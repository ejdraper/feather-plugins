class Snippet < DataMapper::Base
  property :content, :text, :nullable => false
  property :location, :string, :nullable => false, :length => 255
  property :created_at, :datetime
  
  after_save :register
  before_destroy :deregister

  class << self
    @@registered = {}
  end
  
  ##
  # This registers the snippet within the view hooks
  def register
    # Register the snippet view
    Hooks::View.register_view self.id do
      { :name => self.location, :content => self.content }
    end
    # Add the snippet to the array of registered snippets
    @@registered[self.id] = {:location => self.location, :created_at => self.created_at}
  end
  
  ##
  # This deregisters the snippet from the view hooks
  def deregister
    # Deregister the snippet view
    Hooks::View.deregister_view self.id
    # Remove the snippet from the array of registered snippets
    @@registered.delete(self.id)
  end
  
  ##
  # This returns true if the snippet has been registered, false otherwise
  def registered?
    @@registered.include?(self.id)
  end
  
  ##
  # This returns true if the snippet has been registered and is up to date, false otherwise
  def up_to_date?
    self.registered? && @@registered[self.id][:location] == self.location && @@registered[self.id][:created_at] == self.created_at
  end
end