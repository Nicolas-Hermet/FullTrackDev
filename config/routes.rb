Rails.application.routes.draw do
  get '/home', to: 'full_track_dev#home'
  root to: 'full_track_dev#landing'
  get '/contact', to: 'full_track_dev#contact'
  get '/wip', to: 'full_track_dev#wip'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
