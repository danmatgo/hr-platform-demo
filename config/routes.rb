Rails.application.routes.draw do
  devise_for :users
  
  authenticated :user do
    root 'dashboard#index', as: :authenticated_root
  end

  devise_scope :user do
    root to: 'devise/sessions#new'
  end

  get 'dashboard/index'
  resources :payroll_runs
  resources :enrollments
  resources :benefit_plans
  resources :time_entries
  resources :employees
  
  # Custom routes for payroll processing
  post 'payroll/generate', to: 'payroll_runs#generate', as: :generate_payroll
  get 'payroll/report', to: 'payroll_runs#report', as: :payroll_report
  
  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  get "up" => "rails/health#show", as: :rails_health_check
end
