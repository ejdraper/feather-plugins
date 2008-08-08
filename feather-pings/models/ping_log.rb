class PingLog
  include DataMapper::Resource
  
  property :id, Integer, :serial => true  
  property :ping_service_id, Integer
  property :message, String, :nullable => false, :length => 255
  property :successful, Boolean
  property :created_at, DateTime

  validates_present :message, :key => "uniq_ping_log_message"

  def service
    @ping_service ||= PingService[self.ping_service_id]
  end
end