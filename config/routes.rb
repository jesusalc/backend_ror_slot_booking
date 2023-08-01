Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :slots, only: [:create], to: 'slots'
      resources :booked_slots, only: [:create, :index], path: 'booked/slots', to: 'slots#booked_slots' # Changed '/booked_slots' to 'booked/slots'
      resources :all_booked_slots, only: [:index], path: 'booked/slots/all', to: 'slots#all_booked_slots' # Changed '/all_booked_slots' to 'booked/slots/all'
      resources :opens, only: [:create], to: 'opens'
      resources :available_slots, only: [:create, :index], path: 'available/slots', to: 'opens#available_slots' # Changed '/available_slots' to 'available/slots'
      resources :all_available_slots, only: [:index], path: 'available/slots/all', to: 'opens#all_available_slots' # Changed '/all_available_slots' to 'available/slots/all'
    end
  end

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
