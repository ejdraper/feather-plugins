class RecaptchaConfig
  include DataMapper::Resource
  
  property :id, Integer, :key => true
  property :public_key, String, :nullable => false
  property :private_key, String, :nullable => false
  property :theme, String, :nullable => false
  property :lang, String, :nullable => false
  property :tabindex, Integer, :nullable => false
  
  ##
  # This returns the current config, creating them if they aren't found
  def self.current
    config = RecaptchaConfig.first
    config = RecaptchaConfig.create(:public_key => 'public key', :private_key => 'private key', :theme => 'red', :lang => 'en', :tabindex => 0) if config.nil?
    #RCC_PUB = config.public_key
    #RCC_PRIV = config.private_key
    config
  end
end