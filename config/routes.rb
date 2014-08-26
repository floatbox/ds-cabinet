DsCabinet::Application.routes.draw do
  root to: 'pages#index'
  get 'contacts' => 'pages#contacts'

  resources :registrations, only: [:create] do
    post 'confirm'
    post 'regenerate_password'
  end

  resources :access_purchases, only: [:create, :index] do
    post 'success'
    post 'error'
  end

  resources :recoveries, only: [:new, :create] do
    member do
      post :verify
      patch :set_password
      post :regenerate_sms_verification_code
    end
  end

  resources :sessions, only: [:new, :create, :destroy]

  resources :users, only: [:edit, :update] do
    get 'search', to: 'search#index', as: :search
  end

  resources :messages, only: [:edit, :update, :destroy]

  resources :topics do
    resources :messages, only: [:index, :create]
  end

  resources :notifications, only: [:index, :show] do
    get :unread, on: :collection
  end

  resources :attachments

  namespace :concierge do
    resources :users do
      resources :topics
      resources :search_queries, only: :index
      get :concierges, on: :collection
      member do
        get :attach_concierge
        put :attach_concierge_update
        patch :attach_concierge_update
        put :approve
        put :disapprove
        put :toggle_concierge
        get :new_widget
      end
    end
    resources :topics do
      resources :messages, only: [:index, :create]
    end
    resources :tags, only: [:index, :destroy]
    resources :config_items, only: [:index, :update]
    resources :shortcuts, except: [:show]
  end

  # API for Node.js application
  post 'users/token' => 'users#token'
  post 'users/token_light' => 'users#token_light'

  namespace :api do
    namespace :v1 do
      resources :topics, only: :index
      resources :users do
        resources :topics, only: :create
      end
    end
  end



  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
