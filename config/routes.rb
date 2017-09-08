Rails.application.routes.draw do
  root "words#index"

  get 'search/', to: 'search#index', as: 'search'

  devise_for :users, controllers: { registrations: 'users/registrations', sessions: 'users/sessions'}

  resources :words do
    collection do
      get 'check', to: 'words#check'
    end
    resources :votes, only: [:create, :destroy]
    resources :flaggings, only: [:new, :create, :destroy]
    resources :definitions, only: [:new, :create]
  end

  resources :definitions, only: [:edit, :update, :destroy] do
    resources :votes, only: [:create, :destroy]
    resources :flaggings, only: [:new, :create, :destroy]
  end

  resources :tags, only: [:index, :show]
end
