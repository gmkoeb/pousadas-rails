Rails.application.routes.draw do
  devise_for :users, :controllers => {:registrations => "registrations", :sessions => "sessions"}
  root "home#index"
  localized do
    resources :inns, only: [:show, :create, :new, :edit, :update] do
      patch :publish, :draft, on: :member
      get 'search', 'advanced_search', on: :collection
      get 'cities/:city', to: "inns#search_by_city", :as => :search_by_city, on: :collection 
      get '/advanced-search', to: 'inns#advanced_search_form', :as => :advanced_search_form, on: :collection
      resources :rooms, only: [:index, :new, :create]
    end
    resources :rooms, only: [:show, :edit, :update] do
      post 'check', to: 'reservations#check', :as => :check
      patch :publish, :draft, on: :member
      resources :price_per_periods, only:[:new, :create, :destroy]
      resources :reservations, only:[:new, :create]
    end
    
    resources :reservations, only: [:show, :index] do
      patch :cancel, :check_in, :check_out, on: :member
      get :check_out_form, on: :member
      get :active, on: :collection
    end
  end
end
