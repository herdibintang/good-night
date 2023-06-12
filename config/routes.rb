Rails.application.routes.draw do
  resources :sleeps, only: [:index]
  resources :users do
    member do
      post :clock_in, path: "clock-in"
      post :clock_out, path: "clock-out"
      post :follow, path: "follow"
      post :unfollow, path: "unfollow"
      get :sleeps, path: "sleeps"
      get "followings/sleeps", to: "users#followings_sleeps"
    end
  end
end
