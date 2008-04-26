module Admin
  class Redirects < Base
    include_plugin_views __FILE__
    before :find_redirect, :only => %w(edit update delete show)

    def index
      @redirects = Redirect.all
      display @redirects
    end

    def new
      @redirect = Redirect.new
      display @redirect
    end

    def create(redirect)
      redirect["permanent"] = (redirect["permanent"] == "0" ? false : true)
      @redirect = Redirect.new(redirect)
      if @redirect.save
        redirect url(:admin_redirect)
      else
        render :new
      end
    end

    def edit
      display @redirect
    end

    def update(redirect)
      redirect["permanent"] = (redirect["permanent"] == "0" ? false : true)
      if @redirect.update_attributes(redirect)
        redirect url(:admin_redirect, @redirect)
      else
        render :edit
      end
    end

    def delete
      @redirect.destroy!
      redirect url(:admin_redirects)
    end

    def show
      display @redirect
    end

    private
      def find_redirect
        @redirect = Redirect[params[:id]]
      end
  end
end