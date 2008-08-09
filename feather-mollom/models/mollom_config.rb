class MollomConfig
  include DataMapper::Resource
  
  property :id, Integer, :serial => true
  property :private_key, String, :nullable => false
  property :public_key, String, :nullable => false
  ##
  # This returns the current config, creating them if they aren't found
  def self.current
    config = MollomConfig.first(:order => [:id.desc])
    config = MollomConfig.create(:public_key => 'api key', :private_key => "fake") if config.nil?
    config
  end
end
