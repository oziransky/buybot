Buybot::Application.routes.draw do
  devise_for :store_owners
  devise_for :users

  resources :stores

  match '/home', :to => 'pages#home'
  match '/help', :to => 'pages#help'
  match '/invite_friends', :to => 'pages#invite_friends'

  root :to => 'pages#home'
end
