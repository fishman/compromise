Compromise::Application.routes.draw do
  root :to => "home#index"
  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }
  resources :users

  get '/sample_req', to: 'home#sample_req'
end
