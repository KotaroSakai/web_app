Rails.application.routes.draw do
  resources :smoke_records, only: [:new, :create, :edit]
  resources :tobaccos
  resources :posts
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  root "top#index"
  resources :users
end