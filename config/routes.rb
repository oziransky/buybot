Buybot::Application.routes.draw do
  match '/home', :to => 'pages#home'

  root :to => 'pages#home'
end
