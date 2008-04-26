class Redirect < DataMapper::Base
  property :from_url, :string, :nullable => false, :length => 255
  property :to_url, :string, :nullable => false, :length => 255
  property :permanent, :boolean

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