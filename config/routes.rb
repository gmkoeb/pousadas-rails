Rails.application.routes.draw do
  devise_for :users, :controllers => {:registrations => "registrations", :sessions => "sessions"}
  root "home#index"

  resources :inns, only: [:show, :create, :new, :edit, :update]
end
