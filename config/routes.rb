require "sidekiq/web"

Rails.application.routes.draw do
  mount Sidekiq::Web => "/sidekiq"
  
  root "sessions#new"
  get "/analytics", to: "analytics#index"
  resources :items do
    member do
      patch :purchase
      patch :reserve
    end

    collection do
      get :autocomplete
    end
  end
  resources :users

  get "/register", to: "users#new"
  get "/login", to: "sessions#new"
  post "/login", to: "sessions#create"
  delete "/logout", to: "sessions#destroy"

  get "/passwords", to: "passwords#new", as: "new_password"
  post "/passwords", to: "passwords#create", as: "passwords"
  get "/passwords/:user_id/verify_code", to: "passwords#edit", as: "verify_code"
  patch "/passwords/:user_id", to: "passwords#update", as: "password"
  get "/passwords/:user_id", to: "passwords#edit_password", as: "password_form"

  resources :locations

  resources :favorites, only: [:index, :create, :destroy] do
    collection do
      post :create, to: "favorites#create"
    end
  end
end
