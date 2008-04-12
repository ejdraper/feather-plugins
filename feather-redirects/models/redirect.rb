class Redirect < DataMapper::Base
  property :from_url, :string, :nullable => false, :length => 255
  property :to_url, :string, :nullable => false, :length => 255
  property :permanent, :boolean

  def self.find_by_from_url(from_url)
    self.first(:from_url => from_url)
  end
end