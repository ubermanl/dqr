Rails.application.routes.draw do
  
  get 'console_preferences' => 'console_preferences#edit'
  post 'console_preferences' => 'console_preferences#update'
  
  resources :schedules do
    member do 
      get 'schedules'
    end
  end
  resources :schedule_days
  resources :ambiences
  resources :devices
  resources :device_modules do 
    get 'activate'
    get 'deactivate'
  end
  
  get 'module_sensors/get_events' => 'module_sensors#get_events'
  
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'welcome#index'
  
  get 'events' => 'events#index'
  
  resources :user_sessions, only: [:create, :destroy]
  get '/logout', to: 'user_sessions#destroy', as: :logout
  get '/login', to: 'user_sessions#new', as: :login

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
