Rails.application.routes.draw do
  resources :non_staff_costs
  devise_for :users
  root to: "projects#index"
  resources :analysis, only: [:index]
  resources :reporting_periods do
    resources :reports
    resources :bulk_import, only: [:new, :create]
  end
  patch 'reporting_periods/:id/update_state', to: 'reporting_periods#update_state', as: :reporting_period_update_state

  resources :reports, only: [:edit, :update]
  resources :users do
    get 'reports', on: :member
  end
  resources :projects
  resources :contracts do
    get 'reports', on: :member
    get 'costs', on: :member
  end
  get 'my-report', to: 'reports#edit'
  resources :roles
  resources :teams
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
