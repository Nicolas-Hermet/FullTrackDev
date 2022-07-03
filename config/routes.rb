Rails.application.routes.draw do
  resources :articles
  devise_for :admins
  root to: 'static_pages#home'
  get 'static_pages/home'
  get 'static_pages/landing'
  post 'static_pages/landing', to: 'static_pages#contact', as: 'contact'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
