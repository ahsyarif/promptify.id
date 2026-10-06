Rails.application.routes.draw do
  root "prompts#index"

  resources :prompts, only: %i[ index show ] do
    resource :bookmark, only: %i[ create destroy ]
  end
  get "categories/:category", to: "prompts#index", as: :category
  get "saved", to: "bookmarks#index", as: :bookmarks

  resource :session
  resource :registration, only: %i[ new create ]
  get "signup", to: "registrations#new"
  resources :passwords, param: :token
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
end
