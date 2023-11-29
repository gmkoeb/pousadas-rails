Rails.application.routes.draw do
  devise_for :users, :controllers => {:registrations => "registrations", :sessions => "sessions"}
  root "home#index"
  
  resources :inns, only: [:show, :create, :new, :edit, :update] do
    resources :gallery_pictures, only: [:new, :create]
    patch :publish, :draft, on: :member
    get :reviews, on: :member
    get 'search', 'advanced_search', on: :collection
    get 'cities/:city', to: "inns#search_by_city", :as => :search_by_city, on: :collection 
    get 'advanced-search', to: 'inns#advanced_search_form', :as => :advanced_search_form, on: :collection
    resources :rooms, only: [:index, :new, :create]
  end

  resources :rooms, only: [:show, :edit, :update] do
    resources :gallery_pictures, only: [:new, :create]
    patch :publish, :draft, on: :member
    resources :price_per_periods, only:[:new, :create, :destroy]
    resources :reservations, only:[:new, :create]
    post 'check', to: 'reservations#check', :as => :check
  end
  
  resources :reservations, only: [:show, :index] do
    resources :reviews, only: [:create]
    resources :reservation_guests, only: [:create]
    resources :consumables, only: [:new, :create]
    patch :cancel, :check_in, :check_out, on: :member
    get :check_out_form, :check_in_form, on: :member
    get :active, on: :collection
  end

  resources :reviews, only: [:index, :update]
  
  resources :gallery_pictures, only: [:destroy]

  namespace :api do
    namespace :v1 do
      resources :inns, only: [:index, :show] do
        get 'cities', on: :collection
        resources :rooms, only: [:index]
      end

      post '/rooms/:room_id/check', to: 'rooms#check', :as => :check_room
    end
  end
end
