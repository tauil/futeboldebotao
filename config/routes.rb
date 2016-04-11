Rails.application.routes.draw do
  root 'home#index'
  resources :matches
  get 'comparison', to: 'home#comparison'
  get 'update-ranking', to: 'home#update_ranking'
end
