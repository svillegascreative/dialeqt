Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root "words#index"

  get 'search/', to: 'search#index', as: 'search'

  devise_for :users, controllers: { registrations: 'users/registrations', sessions: 'users/sessions'}

  resources :words do
     member do
      put "like", to: "words#like"
      put "dislike", to: "words#dislike"
     end
    resources :definitions, only: [:new, :create]
  end

  resources :definitions, only: [:edit, :update, :destroy] do
     member do
      put "upvote", to: "definitions#upvote"
      put "downvote", to: "definitions#downvote"
     end
  end
end
