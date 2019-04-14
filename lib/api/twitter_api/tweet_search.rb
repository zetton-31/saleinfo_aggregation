module Api
  module TwitterApi
    class TweetSearch
      MAX_LENGTH = 100
      LANG = "ja"
      TYPE = "mixed"
      SINCE_ID = 0
      MAX_ID = 0

      def initialize(client, search_params)
        @client = client
        @search_params = search_params
      end

      def call_search_api
        @client.search(
          @search_params[:search_words],
          count: MAX_LENGTH,
          lang: LANG,
          result_type: TYPE,
          until: @search_params[:target_date],
          exclude: "retweets",
          include_entities: true,
          since_id: SINCE_ID,
          max_id: MAX_ID
        )
      end
    end
  end
end
