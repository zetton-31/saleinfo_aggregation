module Api
  module TwitterApi
    class Client
      MAX_LENGTH = 100
      LANG = "ja"
      TYPE = "mixed"

      def initialize(search_words, target_date)
        @search_words = search_words
        @target_date = target_date
        @since_id = 0
        @max_id = 0
        @tweet_contexts = []
        set_twitter_client
      end

      def search_tweet
        search_result = call_search_api
        format_result(search_result)
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

      def call_search_api
        @client.search(
          @search_words,
          count: MAX_LENGTH,
          lang: LANG,
          result_type: TYPE,
          until: @target_date,
          exclude: "retweets",
          include_entities: true,
          since_id: @since_id,
          max_id: @max_id
        )
      end

      def format_result(search_result)
        search_result.take(100).map do |tw|
          @since_id = tw.attrs[:id] if tw.attrs[:id] > @since_id
          if tw.attrs[:user][:location].present?
            {
              tweet_date: format_date(tw.attrs[:created_at]),
              name:       tw.attrs[:user][:name],
              icon:       tw.attrs[:user][:profile_image_url_https],
              text:       tw.attrs[:text],
              img_url:    tw.attrs[:entities][:media].present? ? tw.attrs[:entities][:media][0][:media_url] : nil,
              tweet_url:  "https://twitter.com/i/web/status/#{tw.attrs[:id]}"
            }
          end
        end
      end

      def format_date(date)
        DateTime.parse(date).strftime("%Y/%m/%d %H:%M:%S").in_time_zone - 10.hours
      end
    end
  end
end
