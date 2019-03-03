Rails.application.routes.draw do
  get 'tweet_lists/get'
  get '/tweet_lists', to: 'tweet_lists#get'

end
