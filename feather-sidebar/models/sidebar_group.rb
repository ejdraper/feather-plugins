class SidebarGroup < DataMapper::Base
  property :title, :string, :nullable => false
  property :content, :text
  property :formatter, :string, :default => "default"

  validates_presence_of :title, :key => "uniq_sidebar_group_title"
end