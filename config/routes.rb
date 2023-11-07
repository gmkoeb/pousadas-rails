Rails.application.routes.draw do
  devise_for :users, :controllers => {:registrations => "registrations", :sessions => "sessions"}
  root "home#index"
  localized do
    resources :inns, only: [:show, :create, :new, :edit, :update] do
      patch :publish, on: :member
      patch :draft, on: :member
      resources :rooms, only: [:index, :new, :create]
    end
    resources :rooms, only: [:show, :edit, :update] do
      patch :publish, on: :member
      patch :draft, on: :member
      resources :price_per_periods, only:[:new, :create, :destroy]
    end
  end
end
