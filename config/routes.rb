Rails.application.routes.draw do
  resources :sleeps
  resources :users
  post "/users/:id/clock-in", to: "users#clock_in"
  post "/users/:id/clock-out", to: "users#clock_out"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
