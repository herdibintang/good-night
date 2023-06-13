Rails.application.routes.draw do
  resources :sleeps, only: [:index]
  resources :users, only:[:create] do
    member do
      post :clock_in, path: "clock-in"
      post :clock_out, path: "clock-out"
      post :follow
      post :unfollow
      get :sleeps
      get :followings
      get "followings/sleeps", to: "users#followings_sleeps"
    end
  end
end
