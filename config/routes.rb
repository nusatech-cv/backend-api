Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      # Sessions
      scope '/auth' do
        post '/google', to: 'sessions#create'
        post '/google/testing', to: 'sessions#check_user'
      end

      resources :services, only: [:index]
      resources :notifications, only: [:index, :update, :destroy]

      resources :orders, only: [:index, :create, :show] do
        member do
          put ':status', to: 'orders#order_status_updated', as: :order_status_updated
          post :payments, to: 'orders#order_payments'
          post :ratings, to: 'orders#order_ratings'
        end
      end

      resources :therapists, only: [:index, :show] do
        collection do
          get :payments, to: 'therapists#payment_order'
        end
      end

      # Private routes for authenticated users
      scope '/users' do
        get '/me', to: 'users#profile'
        put '/role', to: 'users#role'
        put '/registration_token', to: 'users#registration_token'
        get '/activity', to: 'users#activity'
        resources :therapists, only: [:index, :create, :update] do
          member do
            post :services, to: 'therapists#service'
            delete 'services/:service_id/delete', to: 'therapists#service_delete', as: :service_delete
          end
        end
        resources :notification, only: [:index, :update, :destroy]
      end

      # Admin routes
      namespace :admin do
        resources :users, only: [:index, :update, :show] do
          member do
            put :registration_token
          end
          collection do
            get :balance, to: 'balance#show'
          end
        end

        resources :orders, only: [:index, :show]
        resources :payments, only: [:index]
        resources :services, only: [:index, :create, :update, :destroy]
        
        resources :therapist, only: [:index] do
          member do
            get :ratings
          end
        end

        resources :activity_history, only: [:index, :show]
      end
    end
  end
end
