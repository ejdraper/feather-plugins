class RecaptchaConfig < DataMapper::Base
  property :public_key, :string, :nullable => false
  property :private_key, :string, :nullable => false
  property :theme, :string, :nullable => false
  property :lang, :string, :nullable => false
  property :tabindex, :integer, :nullable => false
  
  ##
  # This returns the current config, creating them if they aren't found
  def self.current
    config = RecaptchaConfig.first
    config = RecaptchaConfig.create(:public_key => 'public key', :private_key => 'private key', :theme => 'red', :lang => 'en', :tabindex => 0) if config.nil?
    config
  end
end