Rails.application.routes.draw do
  resources :reporting_periods
  resources :users
  resources :projects
  resources :roles
  resources :teams
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
