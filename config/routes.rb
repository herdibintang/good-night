Rails.application.routes.draw do
  resources :sleeps
  resources :users
  post "/users/:id/clock-in", to: "users#clock_in"
  post "/users/:id/clock-out", to: "users#clock_out"
  post "/users/:id/follow", to: "users#follow"
  post "/users/:id/unfollow", to: "users#unfollow"
  get "/users/:id/followings/sleeps", to: "users#followings_sleeps"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
