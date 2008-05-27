module Admin
  class Releases < Base
    include_plugin_views __FILE__
    before :find_release, :only => %w(edit update delete show)

    def index
      @releases = Release.all
      display @releases
    end

    def new
      @release = Release.new
      display @release
    end

    def create(release)
      @release = Release.new(release)
      if @release.save
        redirect url(:admin_release)
      else
        render :new
      end
    end
    
    def edit
      display @release
    end

    def update(release)
      if @release.update_attributes(release)
        redirect url(:admin_release, @release)
      else
        render :edit
      end
    end

    def delete
      @release.destroy!
      redirect url(:admin_releases)
    end

    def show
      display @release
    end
    
    private
      def find_release
        @release = Release[params[:id]]
      end
  end
end