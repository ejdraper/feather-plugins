class AkismetConfig < DataMapper::Base
  property :api_key, :string, :nullable => false
  
  ##
  # This returns the current config, creating them if they aren't found
  def self.current
    config = AkismetConfig.first
    config = AkismetConfig.create(:api_key => 'api key') if AkismetConfig.nil?
    config
  end
end