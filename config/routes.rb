Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :api, defaults: { format: :json } do
    resources :home, only: [:index]
    resources :time_slots, only: [:index, :create, :update, :destroy]
    resources :appointments, only: [:index, :create]
  end
end
