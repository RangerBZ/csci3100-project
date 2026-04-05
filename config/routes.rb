Rails.application.routes.draw do
  root "sessions#new"
  resources :items
  resources :users

  get "/register", to: "users#new"
  get "/login", to: "sessions#new"
  post "/login", to: "sessions#create"
  delete "/logout", to: "sessions#destroy"

  get "/passwords", to: "passwords#new", as: "new_password"
  post "/passwords", to: "passwords#create", as: "passwords"
  get "/passwords/:user_id/verify_code", to: "passwords#edit", as: "verify_code"
  patch "/passwords/:user_id", to: "passwords#update", as: "password"

  get "/user/:user_id/password", to: "sessions#edit", as: "edit_user_password"
  patch "/user/:user_id/update", to: "sessions#update", as: "user_update"
end
