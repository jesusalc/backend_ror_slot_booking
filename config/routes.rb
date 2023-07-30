Rails.application.routes.draw do
  resources :slots, only: [:create]
  get '/available_slots', to: 'slots#available_slots'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
