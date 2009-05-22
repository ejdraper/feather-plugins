module Feather
  class CommentBlacklist
    include DataMapper::Resource
    
    property :id, Integer, :serial => true
    property :ip_address, String, :default => "127.0.0.1"
    
    validates_present :ip_address
    
    class << self
      # This returns true if the specified IP address is blacklisted
      def is_blacklisted?(ip_address)
        self.count(:conditions => {:ip_address => ip_address}) > 0
      end
    end
  end
end