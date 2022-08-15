Rails.application.routes.draw do
  devise_for :admins
  resources :articles
  resources :youtube, only: :show
  root to: 'static_pages#home'
  get 'static_pages/home'
  get 'static_pages/landing'
  post 'static_pages/landing', to: 'static_pages#contact', as: 'contact'
end
