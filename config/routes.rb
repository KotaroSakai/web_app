Rails.application.routes.draw do
  resources :smoke_records, only: [:index, :new, :create, :edit, :show, :destroy]
  resources :tobaccos
  resources :posts
  resources :posts do
    resources :likes, only: [:create, :destroy]
  end
  resources :send_sets, only: [:new, :create, :show, :edit, :update]

  devise_for :users, controllers: {
    omniauth_callbacks: "omniauth_callbacks"
  }
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  root "top#index"
  resources :users do
    member do
      get :enter_token
      post :validata_token
    end
  end

  post "callback" => "line_bot#callback"
end
