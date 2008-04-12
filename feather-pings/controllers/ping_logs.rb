module Admin
  class PingLogs < Base
    include_plugin_views __FILE__

    def index
      @ping_logs = PingLog.all
      display @ping_logs
    end

    def show
      @ping_log = PingLog[params[:id]]
      display @ping_log
    end
  end
end