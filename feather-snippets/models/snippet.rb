class Snippet < DataMapper::Base
  property :content, :text, :nullable => false
  property :location, :string, :nullable => false, :length => 255
  
  after_save :register_snippet
  before_destroy :deregister_snippet
  
  def register_snippet
    Hooks::View.register_view self.id do
      { :name => self.location, :content => self.content }
    end
  end
  
  def deregister_snippet
    Hooks::View.deregister_view self.id
  end
end