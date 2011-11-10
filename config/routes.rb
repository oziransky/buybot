Buybot::Application.routes.draw do
  devise_for :store_owners
  devise_for :users

  match '/home', :to => 'pages#home'
  match '/stores', :to => 'pages#stores'

  root :to => 'pages#home'
end
