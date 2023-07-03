Rails.application.routes.draw do
  resources :sleeps, only: [:index]
  resources :users, only:[:create, :index, :destroy] do
    member do
      post "sleeps/start", to: "users#sleeps_start"
      post "sleeps/end", to: "users#sleeps_end"
      post :follow
      post :unfollow
      get :sleeps
      get :followings
      get "followings/sleeps", to: "users#followings_sleeps"
    end
  end
end
