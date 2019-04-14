module Api
  module TwitterApi
    class Client

      def initialize(params)
        @params = params
      end

      def search_tweet
        tweet_search = Api::TwitterApi::TweetSearch.new(set_twitter_client, @params)
        tweet_search.call_search_api
      end

    private
      def set_twitter_client
        @client ||= Twitter::REST::Client.new do |config|
          config.consumer_key        = ENV['CONSUMER_KEY']
          config.consumer_secret     = ENV['CONSUMER_SECRET']
          config.access_token        = ENV['ACCESS_TOKEN']
          config.access_token_secret = ENV['ACCESS_TOKEN_SECRET']
        end
      end
    end
  end
end
