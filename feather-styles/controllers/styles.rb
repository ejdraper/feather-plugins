module Admin
  class Styles < Base
    include_plugin_views __FILE__
    before :find_style, :only => %w(edit update delete show)

    def index
      @styles = Style.all
      display @styles
    end
    
    def new
      @style = Style.new
      display @style
    end

    def create(style)
      @style = Style.new(style)
      if @style.save
        expire_all_pages
        redirect url(:admin_style)
      else
        render :new
      end
    end

    def edit
      display @style
    end

    def update(style)
      if @style.update_attributes(style)
        expire_all_pages
        redirect url(:admin_style, @style)
      else
        render :edit
      end
    end

    def delete
      @style.destroy!
      expire_all_pages
      redirect url(:admin_styles)
    end

    def show
      display @style
    end

    private
      def find_style
        @style = Style[params[:id]]
      end
  end
end