Rails.application.routes.draw do
  resources :non_staff_costs
  devise_for :users
  root to: "projects#index"
  resources :analysis, only: [:index]
  resources :project_stacks, only: [:index]
  resources :reporting_periods do
    resources :reports
    resources :bulk_import, only: [:new, :create]
  end
  resources :reports, only: [:edit, :update]
  resources :users
  resources :projects
  resources :contracts, only: [:index, :show] do
    get 'reports', on: :member
    get 'costs', on: :member
  end
  resources :roles
  resources :teams
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
