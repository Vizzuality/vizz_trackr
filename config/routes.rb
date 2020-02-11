Rails.application.routes.draw do
  devise_for :users
  root to: "home#index"
  resources :analysis, only: [:index]
  resources :results, only: [:index]
  resources :non_staff_costs
  resources :reporting_periods do
    resources :reports, only: [:new, :create]
    resources :bulk_import, only: [:new, :create]
    get 'income', on: :collection
    get 'reports', on: :member
    get 'announce', on: :member
  end
  patch 'reporting_periods/:id/update_state', to: 'reporting_periods#update_state', as: :reporting_period_update_state
  get 'slack/:reporting_id/:id', to: 'slack#send_notification', as: :slack_send_notification

  resources :reports, only: [:edit, :update]
  resources :users do
    get 'reports', on: :member
  end
  resources :projects
  resources :contracts do
    resources :progress_reports, only: [:new, :create, :edit, :update]
    member do
      get 'reports'
      get 'team'
      get 'costs'
    end
  end
  get 'my-report', to: 'reports#edit'
  resources :roles
  resources :teams do
    get 'members', on: :member
  end
  resources :rates
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
