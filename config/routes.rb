Rails.application.routes.draw do

  resources :lists do

    collection do
      get 'export'
      get 'download'
    end

    resources :tasks do

      collection do
        get 'export'
        get 'download'

        resources :documents, only: [:new, :create]  do
          collection do
            get :template
          end
        end

      end
    end
  end

  devise_for :users
  
  root to: 'home#index'

  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'

end
