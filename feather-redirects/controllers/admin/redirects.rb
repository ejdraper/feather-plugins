module Feather
  module Admin
    class Redirects < Base
      include_plugin_views __FILE__
      before :find_redirect, :only => %w(edit update delete show)

      def index
        @redirects = Feather::Redirect.all
        display @redirects
      end

      def new
        @redirect = Feather::Redirect.new
        display @redirect
      end

      def create(redirect)
        redirect["permanent"] = (redirect["permanent"] == "0" ? false : true)
        @redirect = Feather::Redirect.new(redirect)
        if @redirect.save
          redirect url(:admin_redirect, @redirect)
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
        @redirect.destroy
        redirect url(:admin_redirects)
      end

      def show
        display @redirect
      end

      private
        def find_redirect
          @redirect = Feather::Redirect[params[:id]]
        end
    end
  end
end