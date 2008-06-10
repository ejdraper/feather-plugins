class SidebarGroup
  include DataMapper::Resource
  
  property :id, Integer, :key => true
  property :title, String, :nullable => false
  property :content, Text
  property :formatter, String, :default => "default"

  validates_present :title, :key => "uniq_sidebar_group_title"
end