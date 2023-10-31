Rails.application.routes.draw do
  devise_for :users
  root "home#index"

  resources :inns, only: [:show, :create, :new]
end
