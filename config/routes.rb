Rails.application.routes.draw do
  
  namespace :api do
    namespace :v0 do
      post '/subscribe', to: 'subscriptions#create'
      patch '/cancel', to: 'subscriptions#update'
      get '/customers/:id', to: 'customers#show'
    end
  end
end
