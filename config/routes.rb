# frozen_string_literal: true

Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :slots, only: [:create], to: 'slots'
      # Changed '/booked_slots' to 'booked/slots'
      resources :booked_slots, only: %i[create index], path: 'booked/slots',
                               to: 'slots#booked_slots'
      # Changed '/all_booked_slots' to 'booked/slots/all'
      resources :all_booked_slots, only: [:index], path: 'booked/slots/all',
                                   to: 'slots#all_booked_slots'
      resources :opens, only: [:create], to: 'opens'
      # Changed '/available_slots' to 'available/slots'
      resources :available_slots, only: %i[create index], path: 'available/slots',
                                  to: 'opens#available_slots'
      # Changed '/all_available_slots' to 'available/slots/all'
      resources :all_available_slots, only: [:index], path: 'available/slots/all',
                                      to: 'opens#all_available_slots'
    end
  end

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
