Rails.application.routes.draw do
  get 'home/index'
  resources :lists do
    resources :tasks
  end
  devise_for :users
  
  root to: 'home#index'

end
