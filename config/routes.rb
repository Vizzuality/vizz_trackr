Rails.application.routes.draw do
  root to: "projects#index"
  resources :analysis, only: [:index]
  resources :project_stacks, only: [:index]
  resources :reporting_periods do
    resources :reports
    resources :bulk_import, only: [:new, :create]
  end
  resources :users
  resources :projects
  resources :roles
  resources :teams
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
