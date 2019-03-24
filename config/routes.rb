Rails.application.routes.draw do
  get '/tweet_search', to: 'tweets#index'
  get '/tweet_lists/', to: 'tweets#search'
  post '/tweet_lists', to: 'tweets#search'

end
