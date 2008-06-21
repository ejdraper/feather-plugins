class Snippet
  include DataMapper::Resource
  
  property :id, Integer, :key => true
  property :content, Text, :nullable => false
  property :location, String, :nullable => false, :length => 255
  property :created_at, DateTime

  class << self
    @@registered = {}

    ##
    # This registers all snippets
    def register_snippets
      # Loop through all snippets
      Snippet.all.each do |snippet|
        # Register the snippet view
        Hooks::View.register_dynamic_view(snippet.location, snippet.content, snippet.id)
        # Add the snippet to the array of registered snippets
        @@registered[snippet.id] = {:location => snippet.location, :created_at => snippet.created_at}
      end
    end

    ##
    # This removes all snippets currently registered
    def deregister_snippets
      # Loop through all registered snippets
      @@registered.keys.each do |id|
        # Deregister the snippet view
        Hooks::View.deregister_dynamic_view(id)
        # Remove the snippet from the registered array
        @@registered.delete(id)
      end
    end
  end
end