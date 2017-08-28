Rails.application.routes.draw do
  root "words#index"

  get 'search/', to: 'search#index', as: 'search'

  devise_for :users, controllers: { registrations: 'users/registrations', sessions: 'users/sessions'}

  resources :words do
    member do
      put 'like', to: 'words#like'
      put 'dislike', to: 'words#dislike'
    end
    collection do
      get 'check', to: 'words#check'
    end
    resources :flaggings, except: [:index, :show, :new]
    resources :definitions, only: [:new, :create]
  end

  resources :definitions, only: [:edit, :update, :destroy] do
     member do
      put 'upvote', to: 'definitions#upvote'
      put 'downvote', to: 'definitions#downvote'
    end
    resources :flaggings, except: [:index, :show, :new]
  end

  resources :tags, only: [:index, :show]
  # resources :flaggings, except: [:index, :show]
end
