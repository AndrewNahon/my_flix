Myflix::Application.routes.draw do
  
  root to: 'pages#front'
  get 'ui(/:action)', controller: 'ui'

  get 'home', to: 'videos#index'
  get 'invalid_token', to: 'pages#invalid_token'
  get 'sign_in', to: 'sessions#new'
  get 'sign_out', to: 'sessions#destroy'
  get 'register', to: 'users#new'
  get 'my_queue', to: 'queue_items#index'
  post 'update_queue', to: 'queue_items#update_queue'
  get 'people', to: 'relationships#index'
  get 'forgot_password', to: 'forgot_passwords#new'
  get 'reset_password/:token', to: 'reset_passwords#new', as: 'reset_password'
  get 'invite_friend', to: 'invitations#new'
  get 'register_invited/:token', to: 'invited_users#new', as: 'register_invited_user'
  
  resources :videos, only: [:show] do 
    collection do 
      get :search, to: 'videos#search'
    end
    
    resources :reviews, only: [:create]
  end
  
  resources :users, only: [:create, :show]
  resources :categories, only: [:show]
  resources :sessions, only: [:create]
  resources :queue_items, only: [:create, :destroy]
  resources :relationships, only: [:create, :destroy]
  resources :forgot_passwords, only: [:create]
  resources :reset_passwords, only: [:create]
  resources :invitations, only: [:create]
  resources :invited_user, only: [:create]
end
