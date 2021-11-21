Rails.application.routes.draw do
  root to: 'torrents#index'
  resources :torrents
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
