class Tweet
  include ActiveModel::Model

  attr_accessor :key_words, :place, :target_date

  validates :place, presence: true
  validates :key_words, presence: true
  validates :target_date, presence: true

end
