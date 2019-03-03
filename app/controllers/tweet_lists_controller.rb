class TweetListsController < ApplicationController
  before_action :set_twitter_client
  def get
    # @tweet_context = @twitter.search("セール", lang: "ja")
    @tweet_contexts = []
    since_id = nil
    tweets = @client.search('セール', count: 100, lang: 'ja', locale: 'Tokyo', result_type: "recent", exclude: "retweets", since_id: since_id)
    tweets.take(100).each do |tw|
        # tweet = tw.full_text
        @tweet_contexts.push(tw.full_text)
      end
  end

  private
    def set_twitter_client
      @client = Twitter::REST::Client.new do |config|
        config.consumer_key        = ENV['CONSUMER_KEY']
        config.consumer_secret     = ENV['CONSUMER_SECRET']
        config.access_token        = ENV['ACCESS_TOKEN']
        config.access_token_secret = ENV['ACCESS_TOKEN_SECRET']
      end
    end
end
