Rails.application.routes.draw do
  authenticate :admin do # Supposing there is a User#admin? method
    mount ActiveAnalytics::Engine, at: "analytics" # http://localhost:3000/analytics
  end

  devise_for :admins
  get 'articles/filter_by_category', to: 'articles#filter_by_category', as: 'filter_by_category'
  resources :articles

  resources :embeds, only: :index
  root to: 'static_pages#home'
  get 'static_pages/home'
  get 'static_pages/landing'
  post 'static_pages/landing', to: 'static_pages#contact', as: 'contact'
end
