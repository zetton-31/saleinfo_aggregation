class TweetsController < ApplicationController
  include Pagy::Backend

  def search
    @tweet = Tweet.new(search_params)
    unless @tweet.valid?
      flash[:warning] = "未入力の項目があります"
      redirect_to tweet_search_path and return
    end

    # TODO:Temporary comment out
    # @tweet_contexts = cache_contents
    if @tweet_contexts.blank?
      search_words = ''
      key_words = @tweet.key_words.split(",")
      key_words.map.with_index(1) do |word, idx|
        search_words.concat("(#{word} #{@tweet.place})")
        search_words.concat("OR") if key_words.length > idx
      end

      twitter_api_client = Api::TwitterApi::Client.new(search_words, @tweet.target_date)
      @tweet_contexts = twitter_api_client.search_tweet
      @tweet_contexts.compact!
      # TODO:Temporary comment out
      # cache_contents
    end
    @pagy, @tweet_contexts = pagy_array(@tweet_contexts, items: 50, params: search_params)
  end

  private
    def search_params
      params.permit(:key_words, :place, :target_date)
    end

    def cache_contents
      Rails.cache.fetch("cache_contents", expired_in: 60.minutes) do
        @tweet_contexts
      end
    end

end
