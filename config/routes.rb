Buybot::Application.routes.draw do

  get "store_auctions/show"

  get "store_auctions/update"

  devise_for :store_owners
  devise_for :users

  resources :stores
  resources :products
  resources :auctions
  resources :store_auctions

  match '/home', :to => 'pages#home'
  match '/help', :to => 'pages#help'
  match '/invite_friends', :to => 'pages#invite_friends'

  root :to => 'pages#home'
end
