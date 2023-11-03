Rails.application.routes.draw do
  devise_for :users, :controllers => {:registrations => "registrations", :sessions => "sessions"}
  root "home#index"

  resources :inns, only: [:show, :create, :new, :edit, :update] do
    patch :publish, on: :member
    patch :draft, on: :member
    resources :rooms, except: [:destroy] do
      patch :publish, on: :member
      patch :draft, on: :member
    end
  end
end
