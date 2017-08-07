Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root "words#index"

  devise_for :users, controllers: { registrations: 'users/registrations', sessions: 'users/sessions'}

  resources :words
  resources :definitions, except: [:index, :show]

end
