Rails.application.routes.draw do
  get 'home/index'
  resources :lists do
    resources :tasks do
      collection do
        get 'export'
        get 'download'
      end
    end
    collection do
      get 'export'
      get 'download'
    end
  end
  devise_for :users
  
  root to: 'home#index'

  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'

end
