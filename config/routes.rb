Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :slots, only: [:create]
      post '/available_slots', to: 'slots#available_slots'
      get '/available_slots', to: 'slots#available_slots'
      get '/all_available_slots', to: 'slots#all_available_slots'
    end
  end

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
