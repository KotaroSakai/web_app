Rails.application.routes.draw do
  resources :smoke_records, only: [:index, :new, :create, :edit, :show, :destroy]
  resources :tobaccos
  resources :posts
  resources :posts do
    resources :likes, only: [:create, :destroy]
  end

  devise_for :users, controllers: {
    omniauth_callbacks: "omniauth_callbacks"
  }
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  root "top#index"
  resources :users

  post "callback" => "line_bot#callback"
end
