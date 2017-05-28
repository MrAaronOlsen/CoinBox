Rails.application.routes.draw do
  root to: 'home#main'

  resources :users, only: [:show, :new, :create] do
    resources :profiles, only: [:show, :edit, :update]
    resources :rewards, only: [:show]
  end

  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
end
