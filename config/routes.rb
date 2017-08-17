Rails.application.routes.draw do
  devise_for :company_operators, controllers: {registrations: 'company_operators/registrations', invitations: 'company_operators/invitations'}
  devise_scope :company_operator do
    get '/company_operators/invitation/update_businesses' => 'company_operators/invitations#update_businesses', :as => 'update_businesses'
    get '/company_operators/pending' => 'company_operators#pending', :as => 'pending_company_operators'
    get '/company_operators/update_businesses' => 'company_operators#update_businesses'
    get '/company_operators/invitations/', to: 'company_operators#invited_not_accepted', as: 'company_operator_invitations'
    match 'company_operators/invitation', to: 'company_operators/invitations#new', via: :get
  end

  devise_for :admins, controllers: {registrations: 'admins/registrations'}
  devise_for :scheme_operators, controllers: {registrations: 'scheme_operators/registrations', invitations: 'scheme_operators/invitations'}
  devise_scope :scheme_operator do
    get '/scheme_operators/pending' => 'scheme_operators#pending', :as => 'pending_scheme_operators'
    get '/scheme_operators/invitations/', to: 'scheme_operators#invited_not_accepted', as: 'scheme_operator_invitations'
    match 'scheme_operators/invitation', to: 'scheme_operators/invitations#new', via: :get
  end

  root 'visitors#index'

  resources :schemes

  resources :registrations, controller: 'businesses/registrations' do
    resources :regular_producers, controller: 'businesses/registrations/regular_producers'
    resources :small_producers, controller: 'businesses/registrations/small_producers'
    resources :material_details, controller: 'businesses/registrations/material_details'
  end

  resources :businesses do
    resources :contacts

    resources :registrations, controller: 'businesses/registrations', only: :index

    get 'scheme_businesses', action: :scheme_businesses
    get 'businesses/scheme_businesses', action: :scheme_businesses
  end

  resources :scheme_operator_invitations, only: :index

  resources :admins, :scheme_operators, :company_operators do
    get 'permissions', action: :permissions
    put 'update_permissions', action: :update_permissions
  end

  resources :scheme_operators, :company_operators do
    get 'approve', action: :approve
  end

  resources :schemes do
    get '/agency_template_uploads/previous_upload_for_year' => 'agency_template_uploads/previous_upload_for_year', :as => 'previous_upload_for_year'
    resources :agency_template_uploads, only: %i(index show new create)
    resources :reports, only: %i(index create)
    get '/reports/report_data' => 'reports/report_data', :as => 'report_data'
  end
end
