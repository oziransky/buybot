Buybot::Application.routes.draw do

  root :to => 'categories#index'

  devise_for :store_owners
  devise_for :users

  resources :stores

  resources :products do
    collection do
      post :upload
      get :new_feed
    end
  end

  resources :auctions do
    collection do
      put :message
      put :drop_shop
    end
  end
  resources :categories
  resources :checkouts

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
   end
  end

  resources :store_auctions do
    collection do
      post :message
    end
  end

  match '/home', :to => 'pages#home'
  match '/help', :to => 'pages#help'

  match '/new_invite', :to => 'pages#new_invite'
  match '/invite_friends', :to => 'pages#invite_friends'
  match '/facebook/callback', :to => 'users#authenticate_fb'

end
