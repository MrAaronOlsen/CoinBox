Rails.application.routes.draw do
  root to: 'home#main'

  resources :users, only: [:show, :new, :create] do
    resources :profiles, only: [:show, :edit, :update]
    resources :rewards, only: [:show]
  end

  resources :users, only: :none do
    resource 'claim', only: :none do
      resources :rewards, only: :show, controller: :claim_reward
    end
  end

  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'

  namespace :admin do
    resources :dashboard, only: :show
    resources :users, only: :show
    resources :rewards
    resources :coins, only: [:new, :create]
  end

end
