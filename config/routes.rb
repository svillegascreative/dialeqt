Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root "words#index"

  devise_for :users, controllers: { registrations: 'users/registrations', sessions: 'users/sessions'}

  resources :words do
    resources :definitions, only: [:new, :create]
  end

  resources :definitions, only: [:edit, :update, :destroy]
end
