module Admin
  class Uploads < Base
    include_plugin_views __FILE__
    before :find_upload, :only => %w(delete show)

    def index
      @uploads = Upload.all
      display @uploads
    end

    def new
      @upload = Upload.new
      display @upload
    end

    def create(upload)
      @upload = Upload.new(upload)
      # Ensure the url starts with /files/
      @upload.url = (@upload.url[0...1] == "/" ? @upload.url : "/#{@upload.url}")
      @upload.url = (@upload.url[0...6] == "/files" ? @upload.url : "/files#{@upload.url}")
      # Create the directory
      # FileUtils.mkdir_p Merb.dir_for(:public) / File.dirname(@upload.url)
      # If a file is present, set the size, content type, and then move the temporary file to the new uploads location
      unless params[:file].nil? || params[:file][:tempfile].nil?
        @upload.size = params[:file][:size]
        @upload.content_type = params[:file][:content_type]
        FileUtils.mv(params[:file][:tempfile].path, (Merb.dir_for(:public) / @upload.url))
        unless File.chmod(0644, @upload.url)  == 0
          raise "Couldn't change permission on #{@upload_url}"
        end
      end
      @upload.created_at = Time.now
      if @upload.save
        redirect url(:admin_upload)
      else
        render :new
      end
    end

    def delete
      @upload.destroy
      # Delete the physical file
      File.delete(Merb.dir_for(:public) / @upload.url)
      redirect url(:admin_uploads)
    end

    def show
      display @upload
    end

    private
      def find_upload
        @upload = Upload[params[:id]]
      end
  end
end