Rails.application.routes.draw do
  get '/tweet_search', to: 'tweets#index'
  get '/tweet_search_bulma_slim', to: 'tweets#index_bulma_slim'
  get '/tweet_search_bulma_html', to: 'tweets#index_bulma_html'
  get '/tweet_lists/', to: 'tweets#search'
  post '/tweet_lists', to: 'tweets#search'

end
