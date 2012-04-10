Buybot::Application.routes.draw do

  resources :facebook_infos

  #get "users/connect_to_fb"

  #get "users/show"

  root :to => 'categories#index'

  devise_for :store_owners
  devise_for :users

  resources :stores
  resources :products
  resources :auctions
  resources :categories

  resources :users do
    collection do
      get :show
      get :connect_to_fb
      get :authenticate_fb
    end
  end
  resources :customer_products do
    collection do
      get :search
      put :start_auction
   end
  end

  resources :store_auctions

  match '/home', :to => 'pages#home'
  match '/help', :to => 'pages#help'
  match '/invite_friends', :to => 'pages#invite_friends'
  match '/facebook/callback', :to=>'users#authenticate_fb'
end
