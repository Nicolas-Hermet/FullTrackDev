Rails.application.routes.draw do
  root to: 'static_pages#landing'
  get 'static_pages/landing'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
