Buybot::Application.routes.draw do


  get "customer_products/search"

  devise_for :store_owners
  devise_for :users

  resources :stores
  resources :products
  resources :auctions
  resources :categories
  match '/home', :to => 'pages#home'
  match '/help', :to => 'pages#help'
  match '/invite_friends', :to => 'pages#invite_friends'

  root :to => 'categories#index'
end
