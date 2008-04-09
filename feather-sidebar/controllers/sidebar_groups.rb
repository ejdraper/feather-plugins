module Admin
  class SidebarGroups  < Base
    include_plugin_views __FILE__

    before :find_sidebar_group, :only => %w(edit update delete show)

    def index
      @sidebar_groups = SidebarGroup.all
      display @sidebar_groups
    end
    
    def new
      @sidebar_group = SidebarGroup.new
      display @sidebar_group
    end
    
    def create(sidebar_group)
      @sidebar_group = SidebarGroup.new(sidebar_group)
      if @sidebar_group.save
        redirect url(:admin_sidebar_groups)
      else
        render :new
      end
    end

    def edit
      display @sidebar_group
    end
    
    def update(sidebar_group)
      if @sidebar_group.update_attributes(sidebar_group)
        redirect url(:admin_sidebar_group, @sidebar_group)
      else
        render :edit
      end
    end
    
    def delete
      @sidebar_group.destroy!
      redirect url(:admin_sidebar_groups)
    end
    
    def show
      display @article
    end

    private
      def find_sidebar_group
        @sidebar_group = SidebarGroup[params[:id]]
      end
    
  end
end