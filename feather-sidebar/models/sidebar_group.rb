class SidebarGroup < DataMapper::Base
  property :title, :string, :nullable => false
  property :content, :text

  validates_presence_of :title, :key => "uniq_sidebar_group_title"
end