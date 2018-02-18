Rails.application.routes.draw do

  namespace :slack do
    resources :events,    only: [:create]
    resources :commands,  only: [:create]
    resources :actions,   only: [:create]
  end
end
