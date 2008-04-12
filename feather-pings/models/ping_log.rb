class PingLog < DataMapper::Base
  property :ping_service_id, :integer
  property :message, :string, :nullable => false, :length => 255
  property :successful, :boolean
  property :created_at, :datetime

  validates_presence_of :message, :key => "uniq_ping_log_message"
  
  def service
    @ping_service ||= PingService[self.ping_service_id]
  end
end