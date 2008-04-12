module Admin
  class Snippets < Base
    include_plugin_views __FILE__

    before :find_snippet, :only => %w(edit update delete show)

    def index
      @snippets = Snippet.all
      display @snippets
    end
    
    def new
      @snippet = Snippet.new
      display @snippet
    end
    
    def create(snippet)
      @snippet = Snippet.new(snippet)
      if @snippet.save
        redirect url(:admin_snippet)
      else
        render :new
      end
    end

    def edit
      display @snippet
    end
    
    def update(snippet)
      if @snippet.update_attributes(snippet)
        redirect url(:admin_snippet, @snippet)
      else
        render :edit
      end
    end
    
    def delete
      @snippet.destroy!
      redirect url(:admin_snippets)
    end
    
    def show
      display @snippet
    end

    private
      def find_snippet
        @snippet = Snippet[params[:id]]
      end
  end
end