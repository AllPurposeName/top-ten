Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  resources :answers, only: [:index, :show]
  resources :guesses, only: [:index, :create]
end
