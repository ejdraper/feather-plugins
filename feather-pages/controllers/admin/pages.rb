module Admin
  class Pages < Base
    include_plugin_views __FILE__
    before :find_page, :only => %w(edit update delete show)

    def index
      @pages = Page.all(:order => [:created_at.desc])
      display @pages
    end

    def show
      display @comment
    end

    def new
      @page = Page.new
      get_pages
      display @page
    end

    def create(page)
      page["published"] = (page["published"] == "1")
      page["display_in_nav"] = (page["display_in_nav"] == "1")
      @page = Page.new(page)
      get_pages
      @parent_selected = params[:page][:parent_id].to_i
      @page.user_id = self.current_user.id
      if @page.save
        # Expire all pages to reflect the newly published page
        expire_all_pages if @page.published
        redirect(url(:admin_pages))
      else
        render :new
      end
    end

    def edit
      get_pages
      @parent_selected = @page.parent_id.to_i
      display @page
    end

    def update(page)
      page["published"] = (page["published"] == "1")
      page["display_in_nav"] = (page["display_in_nav"] == "1")
      if @page.update_attributes(page)
        # Expire all pages to reflect the updated page
        expire_all_pages
        redirect(url(:admin_page, @page))
      else
        get_pages
        @parent_selected = @page.parent_id.to_i
        render :edit
      end
    end
    
    def delete
      @page.destroy!
      # Expire all pages to reflect the removal of the page
      expire_all_pages
      redirect url(:admin_pages)
    end

    private
      def find_page
        @page = Page[params[:id]]
      end
      
      def get_pages
        @pages = Page.all(:order => [:title.asc])
      end
  end
end