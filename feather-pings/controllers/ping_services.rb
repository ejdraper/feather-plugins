module Admin
  class PingServices  < Base
    include_plugin_views __FILE__

    before :find_ping_service, :only => %w(edit update delete show)

    def index
      @ping_services = PingService.all
      display @ping_services
    end
    
    def new
      @ping_service = PingService.new
      display @ping_service
    end
    
    def create(ping_service)
      ping_service["extended"] = (ping_service["extended"] == "0" ? false : true)
      @ping_service = PingService.new(ping_service)
      if @ping_service.save
        redirect url(:admin_ping_services)
      else
        render :new
      end
    end

    def edit
      display @ping_service
    end
    
    def update(ping_service)
      ping_service["extended"] = (ping_service["extended"] == "0" ? false : true)
      if @ping_service.update_attributes(ping_service)
        redirect url(:admin_ping_service, @ping_service)
      else
        render :edit
      end
    end
    
    def delete
      @ping_service.destroy!
      redirect url(:admin_ping_services)
    end
    
    def show
      display @ping_service
    end

    private
      def find_ping_service
        @ping_service = PingService[params[:id]]
      end
  end
end