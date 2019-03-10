class TweetListsController < ApplicationController
  before_action :set_twitter_client

  def get
    @tweet_contexts = []
    @since_id = 0
    @max_id = 0

    keywords = <<-"EOS"
         (セール #新宿)
      OR (SALE #新宿)
      OR (オフ #新宿)
      OR (OFF #新宿)
      OR (還元 #新宿)
      OR (安売り #新宿)
      OR (超割 #新宿)
      OR (格安 #新宿)
      OR (特価 #新宿)
      OR (特売 #新宿)
      OR (特別価格 #新宿)
      OR (限定価格 #新宿)
      OR (お試し価格 #新宿)
      OR (赤字 #新宿)
      OR (お買得 #新宿)
      OR (バーゲン #新宿)
      OR (キャンペーン #新宿)
      OR (感謝祭 #新宿)
    EOS

    tweet_search(keywords)
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

    def tweet_search(keywords)
      tweets = @client.search(
                          keywords,
                          count: 100,
                          lang: "ja",
                          result_type: "recent",
                          exclude: "retweets",
                          include_entities: true,
                          since_id: @since_id,
                          max_id: @max_id
                          )

      @tweet_contexts.concat(tweets.take(100).map do |tw|
        @since_id = tw.attrs[:id] if tw.attrs[:id] > @since_id
        {
          tweet_date: format_date(tw.attrs[:created_at]),
          name:       tw.attrs[:user][:name],
          icon:       tw.attrs[:user][:profile_image_url_https],
          text:       tw.attrs[:text],
          img_url:    tw.attrs[:entities][:media].present? ? tw.attrs[:entities][:media][0][:media_url] : nil,
          tweet_url:  "https://twitter.com/i/web/status/#{tw.attrs[:id]}"
        } if tw.attrs[:user][:location].present?
      end)
      @tweet_contexts.compact!
    end

    def format_date(date)
      DateTime.parse(date).strftime("%Y/%m/%d %H:%M:%S").in_time_zone - 10.hours
    end
end
