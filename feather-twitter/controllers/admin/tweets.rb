module Admin
  class Tweets < Base
    include_plugin_views __FILE__

    before :find_tweet, :only => %w(delete show)

    def index
      @tweets = Tweet.all
      display @tweets
    end

    def delete
      @tweet.destroy!
      expire_index
      redirect url(:admin_tweets)
    end

    def show
      display @tweet
    end

    private
      def find_tweet
        @tweet = Tweet[params[:id]]
      end
  end
end