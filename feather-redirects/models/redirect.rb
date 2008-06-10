class Redirect
  include DataMapper::Resource
  
  property :id, Integer, :key => true
  property :from_url, String, :nullable => false, :length => 255
  property :to_url, String, :nullable => false, :length => 255
  property :permanent, Boolean

  def validate(arg)
    super
    if self.from_url == self.to_url
      self.errors.add "Cannot redirect", "from and to the same url"
      false
    else
      true
    end
  end

  def self.find_by_from_url(from_url)
    self.first(:from_url => from_url)
  end
end