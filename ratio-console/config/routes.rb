Rails.application.routes.draw do

  resources :sensor_types
  resources :devices
  resources :device_types
  resources :ambiences
  resources :users
  resources :user_sessions, only: [:create, :destroy]

  # para disfrazar el login logout
  delete '/sign_out', to: 'user_sessions#destroy', as: :sign_out
  get '/sign_in', to: 'user_sessions#new', as: :sign_in

  root 'welcome#index'

end
