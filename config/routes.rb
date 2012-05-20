Buybot::Application.routes.draw do

  root :to => 'categories#index'

  devise_for :store_owners
  devise_for :users

  resources :stores
  resources :products
  resources :auctions
  resources :categories
  resources :checkouts

  resources :customer_products do
    collection do
      get :search
      put :start_auction
   end
  end

  resources :store_auctions

  match '/home', :to => 'pages#home'
  match '/help', :to => 'pages#help'

  match '/new_invite', :to => 'pages#new_invite'
  match '/invite_friends', :to => 'pages#invite_friends'

end
