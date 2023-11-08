Rails.application.routes.draw do
  devise_for :users, :controllers => {:registrations => "registrations", :sessions => "sessions"}
  root "home#index"
  get '/advanced-search', to: 'advanced_search#index', :as => :advanced_search
  localized do
    resources :inns, only: [:show, :create, :new, :edit, :update] do
      patch :publish, :draft, on: :member
      get 'search', 'advanced_search', on: :collection
      get 'cities/:city', to: "inns#search_by_city", :as => :search_by_city, on: :collection 
      resources :rooms, only: [:index, :new, :create]
    end
    resources :rooms, only: [:show, :edit, :update] do
      patch :publish, :draft, on: :member
      resources :price_per_periods, only:[:new, :create, :destroy]
    end
  end
end
