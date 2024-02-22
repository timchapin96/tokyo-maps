Rails.application.routes.draw do
  devise_for :users
  root to: "pages#home"

  resources :wards, only: %I[index] do
    resources :reviews, only: %I[create]
    resources :messages, only: :create
  end
  resources :reviews, only: [:delete]
end
