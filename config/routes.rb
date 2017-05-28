Rails.application.routes.draw do
  root to: 'home#main'

  resources :users, only: [:new, :create, :show] do
    resources :profile, only: [:edit, :update]
  end

  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
end
