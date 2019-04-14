class Tweet
  include ActiveModel::Model

  attr_accessor :key_words, :place, :target_date

  validates :place, presence: true
  validates :key_words, presence: true
  validates :target_date, presence: true

  def format_result(search_result)
    format_to_array(search_result).compact
  end

  def format_to_array(search_result)
    search_result.take(100).map do |tw|
      # @since_id = tw.attrs[:id] if tw.attrs[:id] > @since_id
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
